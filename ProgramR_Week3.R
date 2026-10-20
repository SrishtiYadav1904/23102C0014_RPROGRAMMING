# Power Operator
2^3
2**3
2^0.5
2**0.5
2^-0.5


# Power Operation with Vectors
c(2,3,5,7)^2
c(2,3,5,7)^c(2,3)
c(1,2,3,4,5,6)^c(2,3,4)
c(2,3,5,7)^c(2,3,4)


# Integer Division (%/%)

## Scalars
2 %/% 2
5 %/% 2
7 %/% 3

## Vector with Scalar
c(2,3,5,7) %/% 2

## Vector with Vector
c(2,3,5,7) %/% c(2,3)
c(2,3,5) %/% c(2,3)


# Modulo Division

## Scalars
2 %% 2
3 %% 2
7 %% 3
7 %% 4

## Vector with Scalar
c(2,3,5,7) %% 2

## Vector with Vector
c(2,3,5,7) %% c(2,3)
c(2,3,5) %% c(2,3)


# Maximum
max(1.2, 3.4, -7.8)

max( c(1.2, 3.4, -7.8))


# Minimum (min())
min(1.2, 3.4, -7.8)

min(c(1.2, 3.4, -7.8))


# Mean (mean())
mean(2, 3, 4)

mean(c(2, 3, 4))


# Absolute Value (abs())
abs(-4)

abs(c(-1, -2, -3, 4, 5))


# Square Root (sqrt())
sqrt(4)

sqrt(c(4, 9, 16, 25))


# Sum (sum())
sum(c(2, 3, 5, 7))


# Product (prod())
prod(c(2, 3, 5, 7))


# Round (round())
round(1.23)

round(1.83)


# Natural Log (log())
log(10)

log(exp(1))

log(c(10, 100, 1000))


# Base-10 Log (log10())
log10(10)

log10(100)

log10(c(10, 100, 1000))


# Assignments
x1 = c(1,2,3,4)
x1

x2 = x1^2
x2


# Combining Functions
c(1,2,3,4) + sum(c(1,2,3,4)) * prod(c(1,2))

sum(c(1,2,3,4)) * prod(c(1,2))

abs(c(1,2,3,4) - sum(c(1,2,3,4)) * prod(c(1,2)))

c(1,2,3,4) - sum(c(1,2,3,4)) * prod(c(1,2))


# Creating a Matrix
x = matrix( nrow = 4, ncol = 2, data = c(1,2,3,4,5,6,7,8) )

x


# Accessing an Element
x[3,2]


# Matrix Filled Row-wise
y = matrix( nrow = 4,ncol = 2, data = c(1,2,3,4,5,6,7,8), byrow = TRUE)
y


# x = matrix(
nrow = 4,
ncol = 2,
data = c(1,2,3,4,5,6,7,8),
dimnames = list(
  c("R1","R2","R3","R4"),
  c("C1","C2")
)
)
