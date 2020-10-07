function V = get_cube(Center, SideLength)

V = [ 1 1 -1 -1  1  1 -1  -1;
     -1 1  1 -1 -1  1  1  -1;
      1 1  1  1 -1 -1 -1  -1];
  
V = V*SideLength;  
  
V = V + Center;
end