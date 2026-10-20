# Addition with Data Vectors
c (2,3,5,7) + c (-2,-3, -5, 8)
c(2,3,5,7) + c(8,9)
c(2,3,5,7) + c(8,9,10)


# Subtraction with Data Vectors
c(2,3,5,7) - c(-2,-3,-5,8)
c(12,13,15,17) - c(8,9)
c(12,13,15,17) - c(8,9,10)


# Multiplication with Data Vectors
c(2,3,5,7) * c(-2,-3,-5,8)
c(2,3,5,7) * c(8,9)
c(2,3,5,7) * c(8,9,10)


# Division with Data Vectors
c(24,20,8,16) / c(3,4,2,8)
c(24,20,8,16) / c(4,2)
c(24,20,8,16) / c(4,2,8)


# Assignment Operator
x <- 20
x
x = 20
x
y = x * 2
y
z = x + y
z
  

# Assigning Characters
x = "apple"
x
x <- "apple1"
x
x = 'apple'
x
x <- 'apple'
x


# Checking Data Types
x = 20

is.numeric(x)
is.character(x)

y = "apple"

is.character(y)
is.numeric(y)


# Converting Number to Character
x = 20

is.numeric(x)

y = as.character(x)

is.numeric(y)
is.character(y)

y


# Converting Character to Number
y = "apple"

is.numeric(y)
is.character(y)

z = as.numeric(y)

is.numeric(z)
is.character(z)

z


# Case Sensitivity
x <- 20
x
X
X <- 30
X
x


# Creating a Vector
y = c(1,2,3,4,5)
y


# Mode of an Object
x = 6
x
mode(x)
y = "apple"
y
mode(y)


# Storage Mode
x = 6
storage.mode(x)

x = TRUE
storage.mode(x)

x = "apple"
storage.mode(x)


# Infinity
3/0

5 + Inf

x = 5 + Inf
is.finite(x)

is.infinite(x)


# R as a calculator
2+3

2*3

2-3

3/2

2*3-4+5/6

(2+3)*5 + 5 - 10

(((2+3)*5 +5) -  10)/2


# Testing if blank space makes a difference
2+5

2 + 5

2   +   5

2    +5


# Addition of scalar with vector
c(2,3,5,7) + 10


# Subtraction of scalar from vector
c(12,13,15,17) - 10


# Multiplication of vector with scalar
c(2,3,5,7) * 10


# Division of vector by scalar
c(12,13,15,17) / 10
