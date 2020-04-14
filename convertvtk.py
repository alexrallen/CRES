# Convert ansys file to vtk for input to Kassiopeia
# Code pulled from ./Kassiopeia/KEMField/Source/Plugins/VTKPart2/src/KElectrostaticPotentialmap.cc

import vtk 

# Range output parameters from ANSYS
r = [(-0.05, 0.05, 0.001)	# X
     (-0.05, 0.05, 0.001)	# Y
     (-0.05, 0.05, 0.001)]	# Z

grid = vtk.vtkImageData()

#X Y Z Size of space being used
grid.SetDimensions(int((r[0][1] - r[0][0])/r[0][2]) + 1,
		   int((r[1][1] - r[1][0])/r[1][2]) + 1,
		   int((r[2][1] - r[2][0])/r[2][2]) + 1)

#Bottom left location of cube being loaded (origin in Kassiopeia will be in center of this cube)
grid.SetOrigin(r[0][0], r[1][0], r[2][0])

#Distance between points (this is a setting in Ansys export)
grid.SetSpacing(r[0][2], r[1][2], r[2][2])

numberOfPoints = int((r[0][1] - r[0][0])/r[0][2]) + 1 * \
		 int((r[1][1] - r[1][0])/r[1][2]) + 1 * \
		 int((r[2][1] - r[2][0])/r[2][2]) + 1
 

valid = vtk.vtkIntArray()
valid.SetName("validity")
valid.SetNumberOfComponents(1)
valid.SetNumberOfTuples(numberOfPoints)
grid.GetPointData().AddArray(valid)

potential = vtk.vtkDoubleArray()
potential.SetName("electric potential")
potential.SetNumberOfComponents(1)
potential.SetNumberOfTuples(numberOfPoints)
grid.GetPointData().AddArray(potential)

field = vtk.vtkDoubleArray()
field.SetName("electric field")
field.SetNumberOfComponents(3)
field.SetNumberOfTuples(numberOfPoints)
grid.GetPointData().AddArray(field)

# Init Valid to Zero
valid.FillComponent(0, 0)

# For loops doing the following
#TODO: Actually write this....
valid.SetTuple(N, 2)
potential.SetTuple(N, pot)
field.SetTuple(N, ef)

# Write the data
writer = vtk.vtkXMLImageDataWriter()
writer.SetFileName("output.vti")
writer.SetInputData(grid)
writer.SetDataModeToBinary()
writer.Write()
