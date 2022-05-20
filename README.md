# Debugging in Matlab

## Interpreting Error Messages

**First thing: Errors are Good !**  
As long as you get errors, you actually get a hint to where you problem is. Only if you don't get any errors, but your code still doesn't work as 
it is intended you start to be in trouble.
Lets have a look at an error message:

```matlab
Operation terminated by user during OrNode/reduce (line 79)  % the first line is where the error actually 
                                                             % happened. And points to a line it occured in.
                                                             % It also says, what the error was. In this case the user
                                                             % stopped the call. So this was probably intentional.
                                                             
In FormulaParser/reduceFormula (line 60)                     % all other lines are what was called to reach this point
      Formula.reduce();                                      % often with the actual code on that line.
      
In Decopmartmentalisemodel (line 297)
      FB.reduceFormula(DNFNode);
```

Always read the error message.It often (not always) gives you hints about what went wrong. E.g. :

```matlab
>> A = ismember({'a','b','c',{'a'})
 A = ismember({'a','b','c',{'a'})
                               |
Invalid expression. When calling a function or indexing a variable, use parentheses. 
Otherwise, check for mismatched delimiters.
```
The error points to a `}` that was seemingly unexpected. Matlab even offers different types of advice (even though they are sometimes not really helpful)
```
Did you mean:
>> A = ismember({'a','b','c',{'a'}})
Not enough input arguments.

Error in cell/ismember (line 34)
        error(message('MATLAB:ISMEMBER:InputClass',class(a),class(b)));
```
Maybe matlab should not suggest calls which lead to errors...

## The (probably) most common error messages

### Example 1:

```matlab
>> n = 9
>> foo = zeros(n,1)

>> for i = 1:10
>>     bar(i) = foo(i);
>> end

Index exceeds the number of array elements. Index must not exceed 9.
```
This is pretty decent infrmation matlab gives here. It tells you that the number of elements are exceeded, and that the maximum index is 9.
This points either to an initialisation problem (i.e. `foo` is too small), or to an indexing issue (the loop should only run for each element in `foo`)

### Example 2:
```matlab
>> linspace = 1:30;
>> square = linspace^2
Error using  ^  (line 52)
Incorrect dimensions for raising a matrix to a power. Check that the matrix is square and the power is a scalar. 
To perform elementwise matrix powers, use '.^'.
```
Again pretty decent error message. It tells you that you can only raise a square matrix to a power, and that to square the elements, you need the pointwise operator. 


### Example 3:
```matlab
>> Variabe1(2,1:2) = Variable2(:);
Unable to perform assignment because the size of the left side is 1-by-2 and the size of the right side is 1-by-3.
```
Matlab tells you that `Variable2` is a 1-by-3 matrix, and we only assign to a 1-by-2 range of `Variable1`. 
Obviously, this was not intended, so either `Variable2` unexpectedly has 3 elements, and we should go check, how `Variable2` was created. Alternatively, we only wanted a smaller slice from `Variable2`, or maybe a larger assignment slice in `Variable1`. 


### Example 4:
```matlab
>> solfe('x-1 = 0','x')
Unrecognized function or variable 'solfe'.
 
Did you mean:
>> solve('x-1 = 0','x')
```

Well, obviously a typo. And matlab actually suggests the correct function.

### Example 5:

```
>> plot(X(a:b),Y(c:d),'v--')
Error using plot
Vectors must be the same length.
```

`a:b` is of a different length then while `c:d`, so the plot function wouldn't know which x-values correspond to which y-values. 
We probably calculated some wrong values when we selected these indices.


## Tracking errors in matlab

### Matlab debugging tool
When an error occurs in a function, it is not clear, what values specific variables had, when the error point was reached. 
To address this, matlab has a built-in debugger, that can easily be activated, by simply clicking on line number of the code line
where you want to set a breakpoint. 
After setting a breakpoint and rerunning the code, the computation will stop at that point and you will be able to inspect all variables that are currently set.
You can also run commands with the current workspace, to see if an error is thrown by a following command.
The biggest issues:
When a problem only occurs after running e.g. a loop 100 times, it is annoying to always click continue until the point the error occurs, and check, whether it actually occured.
In this kind of situation, you could put a `try/catch` block around the code and put your breakpoint into the catch block. 
Then the execution will only be stopped, right when the error was thrown, and you can inspect both the current workspace and the actual error message at the same time. 


### Printf Debugging

If no error occurs but something anyways goes wrong, it can be useful to start using so called "printf" debugging. This means putting in statements that print variable contents to 
either a file or the console. This way you can follow the flow of your code. However, these statements will slow down your code substantially (in particular on triton, where all outputs are 
written to output files). However, sometimes there is no way around these kind of measures if the problem canot be found otherwise. 



## Programming concepts in Matlab and the errors they generate

### Mathematics and floating point arithmetic
Computers need to know what happens when a set of commands is called. For some calulations the results are not
obvious and might not be well defined. "Common" border cases are defined in different standards (have a look [here](https://en.wikipedia.org/wiki/Floating-point_arithmetic#Infinities)). 
For floating point arithmetric for example you commonly have the following definitions:
```matlab
>> log(0)  % log of 0 is defined as infinity
 Inf

>> 10/0  % Division by 0 is defined as infinity (instead of an error)
 Inf

>> 0^0  % 0 times and number is 0 but any number to the power of 0 is 1.
 1

>> Inf * 0 % Infinity time 0 is defined as NaN
 NaN

>> 0/0 % division of 0 by 0 is NaN and not infinity.
 NaN

```
In addition, there is the fact that matlab, until recently, didn't have strings, but only char-arrays. Since chars internally are often simply represented by their ASCII numbers, this lead to code like the following being perfectly fine in matlab, and not throwing an error:
```matlab
>> 'Free' + 3 % 'Free' is a char array, and by adding 3 it is auto-converted to the corresponding double array
 [73 117 104 104]
```

As could be seen above, some mathematical expressions return NaN ("Not a Number"). This is useful to check, whether results are computable.
 However it can also lead to the following issue, which can occur when comparing results that contain NaN:

```matlab
>> NaN == NaN % NaN is not the same as NaN, use `isnan` if you want to check for a value being NaN
 false
 
 >> NaN > 1 % Nan is also neither larger,
 false
 
 >> NaN < 1 % nor smaller than any number. This is due to definitions in the NaN specifications
 false
```

### Operator precedence

When writing down formulas for a computer, one has to be careful how the formula is interpreted. A formula of the type:

$$n \cdot \frac{n-1}{2}$$

is clear for a human. But you can't give it to a computer program in this form (well, at least not in most programming languages).
So implementing it you would write something like:  

```
n * (n - 1) / 2
```

Without the prenthesis, the computer would interpret this formula as:

$$n \cdot n - \frac{1}{2}$$

since it (like in normal math as well) carries out multiplications before additions.
In addition to normal operator (`+,-,*,/,^`) matlab also has for example the complex conjugate `'` operator
and many operators can be combined with `.`, which commonly indicates a point-wise operation. However, for example for the complex conjugate,
combining with `.` generates the transpose operator, and not a pointwise complex conjugate. 

#### Exercise 1

### Cell Arrays and Indexing

Cell Arrays are a powerful tool in matlab, as they can store arbitrary data in a common data structure.
However, there are a few caveats, that often lead to issues:
1. Assignment can be done, either as cell assignment:
```matlab
>> A(1) = X % where X must be a cell itself
>> A(1) = {X} % where whatever X is it is packaged into a cell.
>> X = A(1) % X will be the cell (not the content) of the first element of A
```
2. Assignment by value:
```matlab
>> A{1} = Val % Val can be anything
>> Val = A{1} % Val will be the element contained at position 1 of A
```
The issues start commonly when cell arrays are sliced. 
e.g. You can't assign a single value to multiple cell contents:
```matlab
>> temp = cell(1,2);
>> temp{:} = 'a';
Assigning to 2 elements using a simple assignment statement is not supported. Consider using comma-separated list assignment.
```
The reason is that indexing a slice of cell array contents `myArray{1:3}` is the same as writing `[myArray{1},myArray{2},myArray{3}]`, and thus would need e.g. deal to assign multiple values simultaneously:
```matlab
>> temp = cell(1,2);
>> [temp{:}] = deal('a','a');
>> temp
temp =

  1×2 cell array

    {'a'},{'a'}
```
Alternatively this can be achieved more easily, by wrapping the value you want to assign in a cell and assigning that cell to all cells:
```matlab
>> temp = cell(1,2);
>> temp(:) = {'a'};
>> temp
temp =

  1×2 cell array

    {'a'},{'a'}
```

Cell arrays also offer convenience function like executing command on all elements of a cell array:
```matlab 
>> [Res1,Res2,...] = cellfun(@function, cellarray1, cellarray2,...)
```
The function is applied to all entries in cellarray1, cellarray2 etc and the results stored in Res1, Res2 etc...
Matlab will try to create a uniform output array (not a cell array). e.g. for character array-operatins, it will try to create 
a character array as output (which commonly does not succeed, because the resulting character arrays are not of the same length. 
So, if the output is not necessarily uniform, the parameter pair `'UniformOutput',false` needs to be added, but this always leads to a resulting cell array.

#### Exercise 2

### Visibility

Like other non-compiled languages, shadowing/overloading is a feature (and pitfall) of matlab. Overloading simply means, that you redefine an already defined variable (or function).
The bigger issue is, that overloading a variable can lead to completely useless error messages. 
This is a particular issue in matlab since it uses the same type of syntax for function calls `mean(2,3)` and array indexing `myArray(2,3)`. 
The order in which a variable/functionname is resolved is as follows:
- The currently active workspace (if the code is in a function the workspace defined by the function)
- Additional functions in the same function file
- Functions in the current working directory
- Functions in a folder on the Matlab path (from first to last in the path directories)

A (actually quite common) situation, in which you get an overloading issue could be the following:

```matlab
% You create some scatter plot, and for simplicty simply name it plot:
>> plot = scatter(X,Y)

% then you do some more stuff
....

% and finally you also want to plot some lines with variables you created
>> plot(A,B)
Subscript indices must either be real positive integers or logicals
```

This error message is completely useless, but the only thing matlab sees is that you tried to call the `plot` scatterplot object with two arrays,
which is an invalid way to access variable indices. 


#### Exercise 3 and 4

### Exercise Solutions

There are coded solutions to the exercises in the solutions branch of this repository.
