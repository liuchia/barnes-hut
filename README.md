## Barnes-Hut Simulations
Barnes-Hit simulations are an approximation of n-body simulation which has an asymptotic complexity of O(n *log* n) as opposed to n<sup>2</sup> of most n-body simulations. This is achieved by the usage of octrees (in 3-dimensional space) or quadtrees in 2D space.
In this implementation I will be simulating in 2D.

## Quadtrees
![Quadtrees!](https://i.imgur.com/FUMVf7A.gif)

A quadtree is a tree with potentially four children nodes - each of which can be another quadtree. Each node contains one or zero particles (or more if a maximum depth is specified).

To construct a quadtree, we start with a root which contains all particles. Then we recursively subdivide until each quadtree contains at most one node. 

### Calculating force
The gravitation acceleration due to another particle can be calculated with the following formula:

![...](https://latex.codecogs.com/gif.latex?a%20%3D%20%5Cfrac%7BGm%7D%7Br%5E2%7D) where a is the gravitational acceleration, m is the mass of the other particle, r the distance between them and G the gravitational constant.

In a direct sum approach to the n-body simulation, we add up the accelerations from every other particle. However, in the Barnes-Hut simulation, quadtrees which may contain many particles and are far enough away are treated as a single particle, reducing the number of comparisons.

![Lots of Particles](https://i.imgur.com/iQ3tnss.gif)

## Orbits
![Orbits :o](https://i.imgur.com/Tylqtvm.gif)
A random feature I decided to add was having planets orbit around a central star. Orbits occur when particles are at the correct distance  from the star and travelling at the correct velocity. The formula to get the correct figures is simply : 

![...](https://latex.codecogs.com/gif.latex?v%20%3D%20%5Csqrt%7B%5Cfrac%7BGm%7D%7Br%7D%7D) where v is the orbital velocity, G the gravitational constant, r the distance between them and m the mass of the star.

Of course, other small particles may disrupt the orbit but I made the star really big to compensate :D. 
