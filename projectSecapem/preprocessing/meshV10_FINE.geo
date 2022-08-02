// Parametric definition
lc = 15;
BE = 3.925;         // diameter cylinder
GM = 30.1371;

// Profil glont
Point(1) = {0, 0, 0, lc};                // Point A
Point(2) = {18.8236, -43.175, 0, lc};   // Center OGIVE, Point O
Point(3) = {18.8236, 3.925, 0, lc};     // Point E
Point(4) = {0.9921, 0.4191, 0, lc};     // Point C
Point(5) = {0.573, 0, 0, lc};          // Point G
Point(6) = {0.9921, 0, 0, lc};          // Point F
Point(7) = {26.392, 3.925, 0, lc};     // Point H
Point(8) = {30.71, 3.3655, 0, lc};    // Point K
Point(9) = {30.71, 0, 0, lc};         // Point M

// Domeniu fluid
//Point(10) = {-3*GM, 0, 0, lc};
Point(11) = {-10*GM, 0, 0, lc};
Point(12) = {0, 10*GM, 0, lc};
Point(13) = {16*GM, 10*GM, 0, lc};
//Point(14) = {16*GM, 0, BE, lc};
Point(15) = {16*GM, 0, 0, lc};

Circle(1) = {3, 2, 4};      // OGIVE
Circle(2) = {4, 6, 5};      // Varf MEPLATE

Line(3) = {3, 7};
Line(4) = {7, 8};
Line(5) = {8, 9};

// Linii domeniu
Line(6) = {5, 1};
Line(7) = {1, 11};

Circle(8) = {11, 1, 12};

Line(9) = {12, 13};
Line(10) = {13, 15};
//Line(11) = {14, 15};
Line(12) = {15, 9};

Curve Loop(1) = {10, 12, -5, -4, -3, 1, 2, 6, 7, 8, 9};
Plane Surface(1) = {1};

// Rafinament glont
Field[1] = Box;
Field[1].VIn = 0.075;
Field[1].VOut = 1;
Field[1].XMin = -0.5*GM;
Field[1].XMax = 5.5*GM;
Field[1].YMax = GM;
Field[1].YMin = 0;
Field[1].Thickness = 2;

// Rafinament spate glont
Field[2] = Box;
Field[2].VIn = 0.15;
Field[2].VOut = 1;
Field[2].XMin = 5.5*GM;
Field[2].XMax = 16*GM;
Field[2].YMax = GM;
Field[2].YMin = 0;
Field[2].Thickness = 2;

// Rafinament unda shock
Field[3] = Box;
Field[3].VIn = 0.075;
Field[3].VOut = 1;
Field[3].XMin = 0.5*GM;
Field[3].XMax = 7*GM;
Field[3].YMax = 2*GM;
Field[3].YMin = GM;
Field[3].Thickness = 2;

Field[5] = Box;
Field[5].VIn = 0.15;
Field[5].VOut = 1;
Field[5].XMin = 1.5*GM;
Field[5].XMax = 7*GM;
Field[5].YMax = 4*GM;
Field[5].YMin = 2*GM;
Field[5].Thickness = 2;

Field[6] = Box;
Field[6].VIn = 0.2;
Field[6].VOut = 1;
Field[6].XMin = 4.5*GM;
Field[6].XMax = 12*GM;
Field[6].YMax = 6*GM;
Field[6].YMin = 4*GM;
Field[6].Thickness = 2.5;

Field[7] = Box;
Field[7].VIn = 0.2;
Field[7].VOut = 1;
Field[7].XMin = 7*GM;
Field[7].XMax = 12*GM;
Field[7].YMax = 4*GM;
Field[7].YMin = GM;
Field[7].Thickness = 2.5;

Field[8] = Box;
Field[8].VIn = 0.4;
Field[8].VOut = 1;
Field[8].XMin = 9*GM;
Field[8].XMax = 16*GM;
Field[8].YMax = 10*GM;
Field[8].YMin = 6*GM;
Field[8].Thickness = 3;

Field[9] = Box;
Field[9].VIn = 0.4;
Field[9].VOut = 1;
Field[9].XMin = 12*GM;
Field[9].XMax = 16*GM;
Field[9].YMax = 6*GM;
Field[9].YMin = GM;
Field[9].Thickness = 3;

// Field[4] = MinAniso;
Field[4] = Min;
Field[4].FieldsList = {1, 2, 3, 5, 6, 7, 8, 9};
Background Field = 4;

// To determine the size of mesh elements, Gmsh locally computes the minimum of
//
// 1) the size of the model bounding box;
// 2) if `Mesh.MeshSizeFromPoints' is set, the mesh size specified at
//    geometrical points;
// 3) if `Mesh.MeshSizeFromCurvature' is positive, the mesh size based on
//    curvature (the value specifying the number of elements per 2 * pi rad);
// 4) the background mesh size field;
// 5) any per-entity mesh size constraint.
//
// This value is then constrained in the interval [`Mesh.MeshSizeMin',
// `Mesh.MeshSizeMax'] and multiplied by `Mesh.MeshSizeFactor'. In addition,
// boundary mesh sizes are interpolated inside surfaces and/or volumes depending
// on the value of `Mesh.MeshSizeExtendFromBoundary' (which is set by default).
//
// When the element size is fully specified by a background mesh size field (as
// it is in this example), it is thus often desirable to set

Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;

// This will prevent over-refinement due to small mesh sizes on the boundary.

// Finally, while the default "Frontal-Delaunay" 2D meshing algorithm
// (Mesh.Algorithm = 6) usually leads to the highest quality meshes, the
// "Delaunay" algorithm (Mesh.Algorithm = 5) will handle complex mesh size
// fields better - in particular size fields with large element size gradients:

Mesh.Algorithm = 6;

//Curve discretization
Transfinite Curve {8} = 40 Using Progression 1.0;   // inlet
Transfinite Curve {9} = 40 Using Progression 1.0;    // far-field
Transfinite Curve {10} = 35 Using Progression 0.95;
//Transfinite Curve {11} = 50 Using Progression 1;
Transfinite Curve {7} = 175 Using Progression 1.02;
Transfinite Curve {12} = 450 Using Progression 1.0;
Transfinite Curve {2} = 5 Using Progression 1;
Transfinite Curve {6} = 5 Using Progression 1;

// Refine bullet
Transfinite Curve {1} = 100 Using Progression 1;
Transfinite Curve {3} = 50 Using Progression 1;
Transfinite Curve {4} = 25 Using Progression 1;
Transfinite Curve {5} = 25 Using Progression 1;

//+ Boundary Conditions
Physical Curve("inlet", 17) = {8};
Physical Curve("far-field", 13) = {9};
Physical Curve("outlet", 18) = {10};
Physical Curve("symmetry", 14) = {12, 7};
Physical Curve("bullet", 15) = {5, 4, 3, 1, 2};
//+
Physical Surface("fluid", 16) = {1};
