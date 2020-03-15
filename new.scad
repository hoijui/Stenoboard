
//use <smooth_edges.scad>;

anglePrecission = 0.1;
roundingRadius = 2.0;
rr = roundingRadius;
rr2 = rr * 2;
highRes = false;
//highRes = true;

// key size [width, height, depth]
keySize = [30.0, 5.0, 50.0];

x = keySize[0];
y = keySize[1];
z = keySize[2];





//innerPitDepth = y / 3;
//innerPitRadius = 1.5 * x;
innerPitDepth = 5.0 / 3;
innerPitRadius = 1.5 * 30.0;

// distance of base key structure rectangle to the pit circle center
keyPitCenterDist = innerPitRadius - innerPitDepth;
pitAngleAbstr = acos(keyPitCenterDist / innerPitRadius);
pitAngleStart = 0 - pitAngleAbstr;
pitAngleEnd   = 0 + pitAngleAbstr;





module roundedRect2D(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];
	r = radius;

	$fn = 30;

	linear_extrude(height = z)
	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([r, r, 0])
			circle(r = r);
		translate([x - r, r, 0])
			circle(r = r);
		translate([r, y - r, 0])
			circle(r = r);
		translate([x - r, y - r, 0])
			circle(r = r);
	}
}

module roundedRect3D(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];
	r = radius;

	$fn = 30;

	hull()
	{
		// place a sphere with the given radius in each of the 8 corners
		translate([r, r, r])
			sphere(r = r);
		translate([r, r, z - r])
			sphere(r = r);
		translate([r, y - r, r])
			sphere(r = r);
		translate([r, y - r, z - r])
			sphere(r = r);
		translate([x - r, r, r])
			sphere(r = r);
		translate([x - r, r, z - r])
			sphere(r = r);
		translate([x - r, y - r, r])
			sphere(r = r);
		translate([x - r, y - r, z - r])
			sphere(r = r);
	}
}

module roundedRect2_5D(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];
	r = radius;

	$fn = 30;

	hull()
	{
		// place a sphere with the given radius in each of the 8 corners
		translate([r, r, r])
			translate([0, 0, -r]) difference() { cylinder(h = 2 * r, r = r); translate([-(5 * r), 0, -(1 * r)]) cube([10 * r, 10 * r, 10 * r]); }
		translate([r, r, z - r])
			translate([0, 0, -r]) difference() { cylinder(h = 2 * r, r = r); translate([-(5 * r), 0, -(1 * r)]) cube([10 * r, 10 * r, 10 * r]); }
		translate([r, y - r, r])
			sphere(r = r);
		translate([r, y - r, z - r])
			sphere(r = r);
		translate([x - r, r, r])
			translate([0, 0, -r]) difference() { cylinder(h = 2 * r, r = r); translate([-(5 * r), 0, -(1 * r)]) cube([10 * r, 10 * r, 10 * r]); }
		translate([x - r, r, z - r])
			translate([0, 0, -r]) difference() { cylinder(h = 2 * r, r = r); translate([-(5 * r), 0, -(1 * r)]) cube([10 * r, 10 * r, 10 * r]); }
		translate([x - r, y - r, r])
			sphere(r = r);
		translate([x - r, y - r, z - r])
			sphere(r = r);
	}
}

module roundedRect2_25D(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];
	r = radius;

	$fn = 30;

	hull()
	{
		// place a sphere with the given radius in each of the 8 corners
		translate([r, r, r])
			translate([0, 0, -r]) difference() { cylinder(h = 2 * r, r = r); translate([-(5 * r), 0, -(1 * r)]) cube([10 * r, 10 * r, 10 * r]); }
		translate([r, r, z - r])
			sphere(r = r);
		translate([r, y - r, r])
			sphere(r = r);
		translate([r, y - r, z - r])
			sphere(r = r);
		translate([x - r, r, r])
			translate([0, 0, -r]) difference() { cylinder(h = 2 * r, r = r); translate([-(5 * r), 0, -(1 * r)]) cube([10 * r, 10 * r, 10 * r]); }
		translate([x - r, r, z - r])
			sphere(r = r);
		translate([x - r, y - r, r])
			sphere(r = r);
		translate([x - r, y - r, z - r])
			sphere(r = r);
	}
}

module keySharp(size)
{
	x = size[0];
	y = size[1];
	z = size[2];

	//minkowski() {
		//translate([rr, rr, rr])
		//scale([(width - rr2) / width, (height - rr2) / height, (depth - rr2) / depth])
			difference() {
				// main shape
				//cube(keySize);
				//cube([width - rr2, height - rr2, depth - rr2]);
				roundedRect2_25D(keySize, rr);
				
				// inner/middle "finger bedding"/pit
				innerPitDepth = y / 3;
				innerPitRadius = 1.5 * x;
				translate([x/2, y - innerPitDepth + innerPitRadius, -1.0])
					cylinder(h = z + 2.0, r = innerPitRadius, $fa = anglePrecission);
			}
		//sphere(r = rr, $fa = anglePrecission);
	//}
}

module rounding(size, roundingRadius) {

	//minkowski()
	{
		keySharp(keySize);
		cube(roundingRadius * 2, center = true);
	}
	/*
	//minkowski()
	{
		keySharp(keySize);
		sphere(r = roundingRadius, $fn = 100);
		//cube(roundingRadius * 2, center = true);
	//}
	*/
}

module keySharp2(size)
{
	x = size[0];
	y = size[1];
	z = size[2];
	
	//minkowski()
	{
		//translate([rr, rr, rr])
		//scale([(width - rr2) / width, (height - rr2) / height, (depth - rr2) / depth])
			linear_extrude(convexity = 4)
		    difference() {
				// main shape
				//cube(keySize);
				//cube([width - rr2, height - rr2, depth - rr2]);
				square([x, y]);
				
				// inner/middle "finger bedding"/pit
				innerPitDepth = y / 3;
				innerPitRadius = 1.5 * x;
				translate([x/2, y - innerPitDepth + innerPitRadius, -1.0])
					cylinder(h = z + 2.0, r = innerPitRadius, $fa = anglePrecission);
			}
		sphere(r = roundingRadius, $fn = 100);
	}
/*
	points = [[0,0], [x,0], [x,y], [0,y]];
	polygon(points = points);
*/
}

module drawPitSphere(size, angle)
{
	x = size[0];
	y = size[1];
	z = size[2];
/*	
	echo("XXX : drawPitSphere: why no see?");
	echo(x);
	echo(y);
	echo(innerPitRadius);
*/
	translate([(x / 2) + (innerPitRadius * sin(angle)), (y - innerPitDepth + innerPitRadius) - (innerPitRadius * cos(angle)), 0])
		sphere(r = rr);
}

module drawPitHullPart(size, angle1, angle2)
{
	/*
	hull()
	{
		drawPitSphere(size, angle1);
		drawPitSphere(size, angle2);
	}
	*/
	hull()
	{
		hull()
		{
			translate([0, 0, z]) drawPitSphere(size, angle1);
			drawPitSphere(size, angle1);
		}
		hull()
		{
			translate([0, 0, z]) drawPitSphere(size, angle2);
			drawPitSphere(size, angle2);
		}
	}
}


module keySharp3(size)
{
	x = size[0];
	y = size[1];
	z = size[2];
/*
	echo("XXX : why no see?");
	echo(innerPitRadius);
	echo(keyPitCenterDist);
	echo(pitAngleAbstr);
	echo(pitAngleStart);
	echo(pitAngleEnd);
*/

/*
	//minkowski()
	{
		//translate([rr, rr, rr])
		//scale([(width - rr2) / width, (height - rr2) / height, (depth - rr2) / depth])
			linear_extrude(convexity = 4)
		    difference() {
				// main shape
				//cube(keySize);
				//cube([width - rr2, height - rr2, depth - rr2]);
				square([x, y]);
				
				// inner/middle "finger bedding"/pit
				translate([x/2, y - innerPitDepth + innerPitRadius, -1.0])
					cylinder(h = z + 2.0, r = innerPitRadius, $fa = anglePrecission);
			}
		sphere(r = roundingRadius, $fn = 100);
	}
*/

//	cube(keySize);

	//linear_extrude(convexity = 4)
	union()
	{
		//sphere(r = rr)
		parts = highRes ? 20 : 4;
		assert(floor(parts / 2) * 2 == parts, "Number of parts must be an even number!");
		
		angles = [ for (pi = [0:parts]) pitAngleStart + ((pitAngleEnd - pitAngleStart) / parts * pi) ];
		
		
		//angles[0] = pitAngleStart;
		for (pi = [1:(parts - 0)])
		{
			//angles[pi] = pitAngleStart + ((pitAngleEnd - pitAngleStart) / parts * pi);
			drawPitHullPart(keySize, angles[pi - 1], angles[pi]);
			//translate([(x / 2) + (innerPitRadius * sin(angle)), (y - innerPitDepth + innerPitRadius) - (innerPitRadius * cos(angle)), 0])
			//sphere(r = rr);
		}
		//angles[parts] = pitAngleEnd;
		//drawPitHullPart(keySize, angles[parts - 1], angles[parts]);
	}
}

/**
 * Constructs one side=wall of the form
 * that indents/creates a pit in the key.
 */
module keySharp4PitSideWall(size, roundingRadius)
{
	x = size[0];
	y = size[1];
	z = size[2];
	rr = roundingRadius;
	rr2 = rr * 2;

	translate([-rr, -rr, 0]) translate([x + 2 * y, 0, 0]) square(rr2);
	circle(r = rr, center = true);
}

/**
 * Constructs a Stenoboard-style key.
 */
module keySharp4(size, roundingRadius = 2.0)
{
	x = size[0];
	y = size[1];
	z = size[2];
	rr = roundingRadius;
	rr2 = rr * 2;

	intersection()
	{
		// the (smooth) base structure of the key
		roundedRect2_5D(size, rr);

		// the (smooth) pit for the finger
		{
			pitAngleRange = pitAngleEnd - pitAngleStart;
			//pitOverlapAngle = 2 * pitAngleRange;
			pitOverlapAngle = 180;
			$fn = (360 / pitOverlapAngle) * (highRes ? 80 : 16);
			translate([0, -rr, rr]) 
				translate([x / 2, innerPitRadius - innerPitDepth + y, 0])
				rotate(270 - (pitOverlapAngle / 2))
				rotate_extrude(angle = pitOverlapAngle, convexity = 10)
				translate([innerPitRadius, 0, 0])
				hull()
				{
					keySharp4PitSideWall(size, roundingRadius);
					translate([0, z - rr2, 0])
						keySharp4PitSideWall(size, roundingRadius);
				}
		}
	}
}



//rounding(keySize, rr);
//keySharp(keySize);
//keySharp2(keySize);

//$fn = highRes ? 40 : 8;
//%keySharp3(keySize);
keySharp4(keySize);


/*
$fn = 100;
module base(axis)
{ rotate(90,axis)
     linear_extrude(height=10, center=true, convexity = 2)
       polygon([[ 4, 0],[ 5, 1],[ 5, 4],[ 4, 5],[ 1, 5],
                [ 0, 4],[-1, 5],[-4, 5],[-5, 4],[-5, 1],
                [-4, 0],[-5,-1],[-5,-4],[-4,-5],[-1,-5],
                [ 0,-4],[ 1,-5],[ 4,-5],[ 5,-4],[ 5,-1] ]); }

intersection()
{ base([1,0,0]);
   base([0,1,0]);
   base([0,0,1]); }
*/


// rounding edges
/*
hull() {
	for (i=[0:3])
		translate([(i % 2) * 30, (i - i % 2) * 20, 0]) {
			cylinder(r=5, h=1);
			translate([0, 0, 10]) sphere(5);
		}
}
*/
