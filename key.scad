
use <rounded_cube.scad>;

//roundingRadius = 2.0;
//rr = roundingRadius;
//rr2 = rr * 2;
highRes = false;
//highRes = true;

// key size [width, height, depth]
keySize = [30.0, 5.0, 50.0];

//x = keySize[0];
//y = keySize[1];
//z = keySize[2];







/**
 * Constructs one side-wall of the form
 * that indents/creates a pit in the key.
 */
module keyPitSideWall(size, roundingRadius)
{
	x = size[0];
	y = size[1];
	z = size[2];
	rr = roundingRadius;
	rr2 = rr * 2;

	translate([-rr, -rr, 0])
		translate([x + 2 * y, 0, 0])
		square(rr2);
	circle(r = rr, center = true);
}

/**
 * Constructs a Stenoboard-style key.
 */
module key(size, roundingRadius = undef, pitDepth = undef, pitWidth = undef)
{
	x = size[0];
	y = size[1];
	z = size[2];
	//echo("roundingRadius: ", roundingRadius);
	rr = (roundingRadius == undef) ? (y / 4) : roundingRadius;
	//echo("rr: ", rr);
	rr2 = rr * 2;

	//pitDepth = y / 3;
	//pitRadius = 1.5 * x;
	pd = (pitDepth == undef) ? ((y - 1.0) / 3) : pitDepth;
	//pitDepth = (y - 1.0) / 3;
	pw = (pitWidth == undef) ? (x * 0.85) : pitWidth;
	//pitRadius = 1.2 * x;
	// how to calculate the desired pit angle:
	// (2 * w)^2 + (r - d)^2 = r^2
	// (2 * w)^2 + r^2 - 2*r*d + d^2 = r^2
	// 4*w^2 - 2*r*d + d^2 = 0
	// 4*w^2 + d^2 = 2*r*d
	// (4*w^2 + d^2) / (2*d) = r
	pitRadius = (4*pw*pw + pd*pd) / (2*pd);

	// distance of base key structure rectangle to the pit circle center
	keyPitCenterDist = pitRadius - pd;
	pitAngleAbstr = acos(keyPitCenterDist / pitRadius);
	pitAngleStart = 0 - pitAngleAbstr;
	pitAngleEnd   = 0 + pitAngleAbstr;
	//pitWidth = 2 * sqrt(pitRadius*pitRadius - keyPitCenterDist*keyPitCenterDist);

	//assert((1.0 + pd) < y, "finger pit is too deep");
	assert((1.1 * pd) < y, "finger pit is too deep");
	assert((1.1 * pw) < x, "finger pit is too wide"); // obsolete test, as this one is generated

	intersection()
	{
		// the (smooth) base structure of the key
		rounded_cube_2_5D(size, rr);

		// the (smooth) pit for the finger
		{
			pitAngleRange = pitAngleEnd - pitAngleStart;
			//pitOverlapAngle = 2 * pitAngleRange;
			pitOverlapAngle = 180;
			$fn = (360 / pitOverlapAngle) * (highRes ? 80 : 16);
			translate([0, -rr, rr]) 
				translate([x / 2, pitRadius - pd + y, 0])
				rotate(270 - (pitOverlapAngle / 2))
				rotate_extrude(angle = pitOverlapAngle, convexity = 10)
				translate([pitRadius, 0, 0])
				hull()
				{
					keyPitSideWall(size, rr);
					translate([0, z - rr2, 0])
						keyPitSideWall(size, rr);
				}
		}
	}
}


key(keySize);


