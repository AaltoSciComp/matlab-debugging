# Matlab debugging exercises

This repository contains a few Exercises files for Matlab Debugging along with pitfals using a few basic concepts like operator precedence, cell array access and overloading/visibility. 

## Operator precedence

1. Operator precedence can interfere with results sometimes in very drastic ways. Therefore it is always
   useful to enclose individual operations in parenthesis. Symbolic variables ( [syms](http://nl.mathworks.com/help/symbolic/syms.html) ) can be used to create
   place holders in a formula. They provide the option to first encode the formula and then evaluate it
   with different variable settings.
   * Define the term `term = 3ˆ2*x - yˆ3 - 5 / 4` using symbolic variables for x and y and evaluate
     ( [eval](https://nl.mathworks.com/help/matlab/ref/eval.html) ) it for `x = 3` and `y = 2` .
   * What is the difference between the matlab formula above and the term below (1). Which
     operator precedence rules make the use of parenthesis necessary when implementing Term 1?

     <img src="https://render.githubusercontent.com/render/math?math=3^{2x} - \frac{y^3 - 5}{4}">
     
   * Implement a function res = calculateterm(x,y), that calculates the term in one assignment using
     parenthesis.
     
2. Quadratic equations of the form `a x 2 + b x + c` commonly have one or two solutions which can be
   easily determined as:
   
   <img src="https://render.githubusercontent.com/render/math?math=x_1,x_2 = \frac{-b}{2a} \pm\sqrt{\frac{b^2}{4a^2} - \frac{c}{a}}">
   
   You can find a (erronous) implementation of this equation in the [solveSquareFunction.m](exercises/solveSquareFunction.m) file. Test the
   function on the following two parameter sets:
   * a = 1, b = 2, c = -7
   * a = 2, b = 5, c = -7
   
   Matlab has builtin functionality to solve systems of linear equations [solve](http://se.mathworks.com/help/symbolic/solve.html). Compare the
   results of solveSquareFunction to the solution of solve.  
   Find the mistake in solveSquareFunction. Correct it and explain what was causing the error
   and why you did your corrections.
   
## Cell arrays and indexing

3. Cell arrays are a special type of matlab arrays which are used for multiple purposes, and can store
   multiple different datatypes. They can be accessed in two ways. By accessing the cells using () or
   by accessing the contents of the cells using {}. To assign data to a slice of a cell array, there are
   multiple options:
   1. To assign the same content to a slice of cells you can use e.g. `bar(1:3) = {CellContent}`.
   2. To assign multiple different values you can either build a cell array of those values ( `foo = {'A',1,'C'}` )
and call `bar(1:3) = foo` 
      or you can use the [deal](https://nl.mathworks.com/help/matlab/ref/deal.html) function `[bar{1}, bar{2}, bar{3}] = deal('A',1,'C')`
   * What are the differences between the calls `bar{1:3}` and `bar(1:3)`?
   * Create an empty 4 x 4 cell array named myCellArray .  
     Try to set the content of the array so that each cell contains the string "This is a String in a
     Cell", using the call `myCellArray: = 'This is a String in a Cell'`.  
     Try to set the cells of the second row to contain the values 1, 2, 3, 4 in column 1, 2, 3, 4
     respectively using the call `myCellArray{2,1:4} = deal(1,2,3,4)`  
     These calls will lead to errors. Explain what is wrong in the calls (e.g. what do the left and
     right hand sides of the assignments represent).
     
4. The file [getNormalisedExpression.m](exercises/solveSquareFunction.m) is supposed to normalise gene expression data. However there is an error in the function
   * Run the function using the provided [ExprData.xlsx](data/ExprData.xlsx). Report the error.
   * Explain the error, what does it tell you?
   * Correct the error and explain what kind of mistake was done.


## Overloading/Visibility
5. [plotFilteredNormData](exercises/plotFilteredNormData.m) normalises data to a 0-1 range and plots the data in a scatter plot to
   illustrate the distribution. It has the option to use minimum and maximum values to restrict the
   “relevant” information (i.e. if the user is only interested in a certain part of the data). The input
   data has to be a matrix with two columns. The minimum and maximum values will be applied to
   the second column (i.e. any row for which the second column is smaller than min or larger than
   max is ignored). Some sample data for the height of people of a certain age is provided on moodle
   ([HeightData.xls](data/HeightData.xls)). Again, there is an error in the function, that make the function throw an error.
   * Read in the data (use [xlsread](http://nl.mathworks.com/help/matlab/ref/xlsread.html)) and try to use it with the function. What is the error and what
     causes it?
   * Fix the error in the function and use it to plot the data for ages 14-30.   
   
## More serious debugging

6. Have a look at the file [plotDemographics.m](exercises/plotDemographics.m). This file should plot statistical data of US
   states on a map of the US. Data that can be plotted is available in the [USStates.csv](data/USStates.csv) file. The
   data has multiple columns that contain the data for different population groups. plotdemographics
   accepts a filename followed by the column header of the column containing the data. Finally if the
   file you read is a is not in the default format (e.g. USStates.csv does not use comma but tab as its
   separator) this has to be indicated in the third argument (e.g. `'tab'` as third argument). The aim of
   this exercise is to provide you with experience in how to find a problem in a more complex setup.
   As such it should be done individually. The important part of this exercise is that you document
   the procedure of debugging (Which part/lines of the code did you investigate and why. Where did
   you look next ...).
   * Find the mistake in the function and correct it, documenting the process by explaining the
     procedure you used, and the reasoning for each step.
   * You will notice that there is a state missing in the map. As above find the mistake and detail
     your approach to find and correct it.


## Solutions

Corrected functions can be found in the solutions folder. 
