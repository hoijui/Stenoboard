/*
 This is an OpenSCAD module to smooth both concave and convex edges.

 Copyright (C) 2017 trzeci (nickname on thingiverse.com)
 This file is licensed under "Creative Commons - Attribution" license.
 Details about the license can be found here:
 http://creativecommons.org/licenses/by/3.0/
 Machine readable license information:
 <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

 The file was obtained from here:
 https://www.thingiverse.com/thing:2358974
*/

module smooth_concave(r=1,fn=$fn)
{
  difference()
  {
    cube(1000-3*r,center=true);
    //minkowski()
    union()
    {
      difference()
      {
        cube(1000,center=true);
        //minkowski()
        union()
		{
          children();
          sphere(r=r,$fn=fn);
        }
      }
      sphere(r=r,$fn=fn);
    }
  }
}

module smooth_convex(r=1,fn=$fn)
{
  minkowski()
  {
    difference()
    {
      cube(1000-3*r,center=true);
      minkowski()
      {
        difference()
        {
          cube(1000,center=true);
          children();
        }
        cube(2*r,center=true);
      }
    }
    sphere(r=r,$fn=fn);
  }
}

module smooth(r=1,fn=$fn)
{
  smooth_concave(r,fn)
    smooth_convex(r,fn)
      children();
}



module o()
{
  cube(10,center=true);
  cube([3,3,20],center=true);
}

/*
$fn=12;
translate([-6,0,0])
  smooth_concave()
    o();
translate([6,0,0])
  smooth_convex()
    o();
translate([18,0,0])
  smooth()
    o();
*/
