

/**
 * Creates a cube with a given size which is rounded/smoothed
 * in 2 dimensions.
 */
module rounded_cube_2D(size, radius = undef, $fn = 30)
{
	x = size[0];
	y = size[1];
	z = size[2];
	assert(x != undef, "width undefined");
	assert(y != undef, "height undefined");
	assert(z != undef, "depth undefined");
	r = (radius == undef) ? min(x, y, z) / 4 : radius;
	assert((2 * r) <= min(x, y, z), "rounding radius is too large");

	linear_extrude(height = z)
	hull()
	{
		// place a circle with the given radius
		// in each of the 4 corners
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

/**
 * Creates a cube with a given size which is rounded/smoothed
 * in 3 dimensions.
 */
module rounded_cube_3D(size, radius = undef, $fn = 30)
{
	x = size[0];
	y = size[1];
	z = size[2];
	assert(x != undef, "width undefined");
	assert(y != undef, "height undefined");
	assert(z != undef, "depth undefined");
	r = (radius == undef) ? min(x, y, z) / 4 : radius;
	assert((2 * r) <= min(x, y, z), "rounding radius is too large");

	hull()
	{
		// place a sphere with the given radius
		// in each of the 8 corners
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

module round_part_2D(r)
{
	translate([0, 0, -r])
		difference()
		{
			cylinder(h = 2 * r, r = r);
			translate([-(5 * r), 0, -(1 * r)])
				cube([10 * r, 10 * r, 10 * r]);
		}
}

/**
 * Creates a cube with a given size which is rounded/smoothed
 * in 2.5 dimensions.
 */
module rounded_cube_2_5D(size, radius = undef, $fn = 30)
{
	x = size[0];
	y = size[1];
	z = size[2];
	assert(x != undef, "width undefined");
	assert(y != undef, "height undefined");
	assert(z != undef, "depth undefined");
	r = (radius == undef) ? min(x, y, z) / 4 : radius;
	assert((2 * r) <= min(x, y, z), "rounding radius is too large");

	hull()
	{
		// place a sphere with the given radius
		// in the 4 top corners,
		// and a circle in each of the 4 bottom corners
		translate([r, r, r])
			round_part_2D(r);
		translate([r, r, z - r])
			round_part_2D(r);
		translate([r, y - r, r])
			sphere(r = r);
		translate([r, y - r, z - r])
			sphere(r = r);
		translate([x - r, r, r])
			round_part_2D(r);
		translate([x - r, r, z - r])
			round_part_2D(r);
		translate([x - r, y - r, r])
			sphere(r = r);
		translate([x - r, y - r, z - r])
			sphere(r = r);
	}
}

/**
 * Creates a cube with a given size which is rounded/smoothed
 * in 2.25 dimensions.
 */
module rounded_cube_2_25D(size, radius = undef, $fn = 30)
{
	x = size[0];
	y = size[1];
	z = size[2];
	assert(x != undef, "width undefined");
	assert(y != undef, "height undefined");
	assert(z != undef, "depth undefined");
	r = (radius == undef) ? min(x, y, z) / 4 : radius;
	assert((2 * r) <= min(x, y, z), "rounding radius is too large");

	hull()
	{
		// place a sphere with the given radius
		// in the 4 top and 2 far bottom corners,
		// and a circle in each of the 2 bottom front corners
		translate([r, r, r])
			round_part_2D(r);
		translate([r, r, z - r])
			sphere(r = r);
		translate([r, y - r, r])
			sphere(r = r);
		translate([r, y - r, z - r])
			sphere(r = r);
		translate([x - r, r, r])
			round_part_2D(r);
		translate([x - r, r, z - r])
			sphere(r = r);
		translate([x - r, y - r, r])
			sphere(r = r);
		translate([x - r, y - r, z - r])
			sphere(r = r);
	}
}
