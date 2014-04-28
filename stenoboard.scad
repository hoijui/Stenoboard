/**
 * Stenoboard is an open source stenographic keyboard.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright 2014 Emanuele Caruso. See LICENSE for details.
 */

// VALUES


hKeyDistance = 18.325;
vowelsKeyDistance = 14.5;
framePosition = [-17.75, -69.5, 0];
drawKeySupport = false;
drawKeySurfaceDifference = true;
keySurfaceDifferenceFn = 128;

boardCenter = [46,-41.25,0];
rightRReference = boardCenter + [-hKeyDistance * 1.5, -22, 0];
rightEReference = rightRReference + [-11.3, -27, 0];
screwFrameVerticalOffset = 8.7;
leftVowelsOffset = 11.3 * 2 + hKeyDistance * 3 - 14.5;
screw1 = [103.9, 2.5, 0];
screw2 = [-12.75, 2.5, 0];
screw3 = [-12.75, -62.5, 0];
screw4 = [103.9, -62.5, 0];
frameScrewPositions = [screw1, screw2, screw3, screw4];
frameScrewD = 3.2;
mainRightScrewPositions = [[-37.465,11.43,0], [40.64,13.97,0], [-34.29,-10.795,0], [34.925,-10.795,0]];
mainRightScrewBevels = [[false, false, true, false], [true, false, false, true], [false, true, true, true], [true, false, true, true]];
mainRightScrewH = 19.2;
mainRightScrewD = 3.5;
mainLeftScrewPositions = [[-16.51,12.065,0], [40.005,13.335,0], [-34.29,-10.795,0], [36.83,-11.43,0]];
mainLeftScrewBevels = [[true, true, true, true], [true, true, true, true], [true, true, true, true], [true, true, true, true]];
rightVowelsScrewPositions = [[-1.27,9.525,0], [16.51,9.525,0], [7.62,-9.525,0]];
rightVowelsScrewBevels = [[true, true, true, true], [true, true, true, true], [true, true, false, false]];
rightVowelsScrewH = mainRightScrewH - 9.3;
rightVowelsScrewD = 3.5;
arduinoScrewPositions = [[0, 0, 0], [50.8, -15.2, 0], [50.8, -15.2 - 27.9, 0], [-1.3, -15.2 -27.9 -5.1, 0]];
arduinoScrewOffset = [-17.5, 45, 0];
arduinoScrewH = 6;
arduinoScrewD = 3;
rightVowelsBasePosition = [-8.5, -107, 0];
rightVowelsBaseScrewD = 3.5;
%translate(boardCenter) cylinder(r=1,h=10,$fn=6);
%translate(rightRReference) cylinder(r=1,h=10,$fn=6);
%translate(rightEReference + [0, 0, 30]) cylinder(r=1,h=10,$fn=6);
%translate(frameScrewPositions[0]) cylinder(r=1,h=50,$fn=6);
%translate(frameScrewPositions[1]) cylinder(r=1,h=50,$fn=6);
%translate(frameScrewPositions[2]) cylinder(r=1,h=50,$fn=6);
%translate(frameScrewPositions[3]) cylinder(r=1,h=50,$fn=6);



// MODULE CALLS


//translate([-46, 35, 0]) consonantsKeyboard(keys = 6, numberKeyIndex = 3, rightWideKeyIndex = 0, leftWideKeyIndex = 5, drawTopRow = true, drawBottomRow = true, drawFrame = true);
translate([-46, 10, 0]) translate([0, 0, 2]) barKeyboard();
//barButtonContact();
//rightBaseBridgeTest();
//translate([-46, 50, 0]) base();
//translate([0, 130, 0])
//translate([-46, 50, 0]) base(isRight = false);
//translate([0, 0, rightVowelsScrewH + screwFrameVerticalOffset + 0.2])
//translate([-14.5, 75, 0]) vowelsKeyboard();



// MODULES


module keyArm(armWidth = 4, armLength = 50, armHeight = 5, pivotDepth = 4) {
  translate([0, -armLength / 2, armHeight / 2]) beveledCube([armWidth, armLength, armHeight], center = true, bevelY = [true, false]);
}

module beveledCube(cubeEdges, center = false, bevelR = 2, bevelSegments = 5, bevelX = [true, true], bevelY = [true, true]) {
  difference() {
    cube(cubeEdges, center = center);
    translate([center ? 0 : cubeEdges[0] / 2, center ? 0 : cubeEdges[1] / 2, 0])
    for (i = [0 : 1]) for (j = [0 : 1]) if(bevelX[i] && bevelY[j]) {
      mirror([i, 0, 0]) mirror([0, j, 0]) translate(center ? [-cubeEdges[0] / 2, -cubeEdges[1] / 2, 0] : [-cubeEdges[0] / 2, -cubeEdges[1] / 2, cubeEdges[2] / 2]) bevel(r = bevelR, length = cubeEdges[2] + 0.01, segments = bevelSegments);
    }
  }
}

module bevel(r = 2, length = 100, segments = 5, minThickness = 0) {
  difference() {
    cube([(r + minThickness) * 2, (r + minThickness) * 2, length], center = true);
    translate([r, r, 0]) cylinder(r = r, h = length * 2, center = true, $fn = segments * 4);
    for (i = [0, 1]) rotate([0, 0, i * -90]) translate([-0, -r * 2 - 0.001, 0]) cube([r * 4, r * 4, length*2], center = true);
  }
}

module topRowKeySurface(keyW = 13, keyD = 25, keyH = 1.25, drawDifference = true, isRightWideKey = false, isLeftWideKey = false, drawDifference = true) {
  difference() {
    translate([-keyW / 2 + (isLeftWideKey ? -2.5 : 0), -keyD / 2, 0]) beveledCube([keyW + (isLeftWideKey ? 2.5 : 0) + (isRightWideKey ? 2.5 : 0), keyD, keyH]);
    if(drawKeySurfaceDifference && drawDifference) translate([0, 0, 29.5 + keyH]) rotate([90, 0, 0]) cylinder(r = 30, h = 50, center = true, $fn = keySurfaceDifferenceFn);
  }
}

module bottomRowKeySurface(keyW = 13, keyD = 25, keyH = 1.25, isRightWideKey = false, isLeftWideKey = false, drawDifference = true) {
  difference() {
    translate([-keyW / 2 + (isLeftWideKey ? -2.5 : 0), -keyD / 2, 0]) beveledCube([keyW + (isLeftWideKey ? 2.5 : 0) + (isRightWideKey ? 2.5 : 0), keyD, keyH]);
    if(drawKeySurfaceDifference && drawDifference) {
      translate([0, 25 - (keyD / 2 - keyW / 2), 29.5 + keyH]) rotate([90, 0, 0]) cylinder(r = 30, h = 50, center = true, $fn = keySurfaceDifferenceFn);
      translate([0, -(keyD / 2 - keyW / 2), 29.53 + keyH]) sphere(r = 30, $fn = keySurfaceDifferenceFn);
    }
  }
}

module numberBarSurface(keyW = 13, keyD = 25, keyH = 1.25, drawDifference = true, keys = 5, drawDifference = true) {
  rotate([0, 0, 180]) difference() {
    translate([-keyW / 2 - hKeyDistance * (keys - 1), -keyD / 2, 0]) beveledCube([keyW + hKeyDistance * (keys - 1), keyD, keyH]);
    if(drawKeySurfaceDifference && drawDifference) {
      for (i = [0 : keys - 1]) translate([-i * hKeyDistance, -(keyD / 2 - keyW / 2) +1, 29.53 + keyH]) sphere(r = 30, $fn = keySurfaceDifferenceFn);
    }
  }
}

module topRowKeyAssembly(pivotLength = 16.5, pivotHeight = 5, pivotDepth = 3.25, coneR1 = 2.5, coneH = 3, tolerancePerSide = 0.25, armWidth = 12, armLength = 40, armHeight = 1.5, topKeyW = 13, topKeyD = 25, topKeyH = 2, keySupportH = 0, verticalKeySupportH = 0, backlash = 0.0, isRightWideKey = false, isLeftWideKey = false) {
  translate([0,1,0]) carvedArm(armL = armLength - 3, armW = armWidth, levelH = 0.4, firstLevelH = 0.8, levelTranslateIncrement = 2.5, levels = 2, drawFakeKey = false);
  armHeight = 1 + 2 * 0.25;
  translate([0, -armLength + topKeyD / 2, verticalKeySupportH + keySupportH]) topRowKeySurface(keyW = topKeyW, keyD = topKeyD, keyH = topKeyH, isRightWideKey = isRightWideKey, isLeftWideKey = isLeftWideKey);
  echo("top row h:", verticalKeySupportH + keySupportH + topKeyH);
}

module bottomRowKeyAssembly(pivotLength = 16.5, pivotHeight = 5, pivotDepth = 3.25, coneR1 = 2.5, coneH = 3, tolerancePerSide = 0.25, armWidth = 12, topArmLength = 35, armLength = 20, keyW = 13, keyD = 23, keyH = 2, topKeyD = 25, keySupportH = 0, verticalKeySupportH = 0, armsGap = 1, bridgeGap = 2, isRightWideKey = false, isLeftWideKey = false) {
  rotate([0, 0, 180]) translate([0, topArmLength + armLength + 2.5, 0]) carvedArm(armL = armLength, armW = armWidth, levelH = 0.8, firstLevelH = 0.4, levelTranslateIncrement = 3, levels = 2, drawFakeKey = false);
  armHeight = 1;
  difference() {
    union() {
      translate([0, 5 - topArmLength - keyD / 2 - 2.5, verticalKeySupportH + keySupportH]) bottomRowKeySurface(keyW = keyW, keyD = keyD, keyH = keyH, isRightWideKey = isRightWideKey, isLeftWideKey = isLeftWideKey);
    }
    if (!isRightWideKey) for (i = [0, -1]) mirror([i, 0, 0]) translate([-keyW / 2 + (isLeftWideKey && i == 0 ? - 2.5 : 0), 5 - topArmLength - keyD - 2.5, armHeight]) bevel(r = keyW / 2, segments = 12);
    else for (i = [0, -1]) mirror([i, 0, 0]) translate([-keyW / 2 + (isRightWideKey && i == 0 ? 0 : -2.5), 5 - topArmLength - keyD - 2.5, armHeight]) bevel(r = keyW / 2, segments = 12);
  }
  echo("bottom row h:", verticalKeySupportH + keySupportH + keyH);
}

module numberBarAssembly(pivotLength = 16.5, pivotHeight = 5, pivotDepth = 3.25, coneR1 = 2.5, coneH = 3, tolerancePerSide = 0.25, armWidth = 3.5, armLength = 40, topKeyW = 13, keyD = 7.5, topKeyH = 2, keySupportH = 0, verticalKeySupportH = 0.4, backlash = 0.0, keys = 5, numberKeyIndex = 2) {
 armHeight = 1 + 2 * 0.25;
 translate([0,0.01,0]) union() {
  translate([-9.14 + numberKeyIndex * hKeyDistance, 0, 0]) carvedArm(armL = armLength, armW = 3.5, levelH = 1.6, firstLevelH = 0.4, levelTranslateIncrement = 2, levels = 2, drawFakeKey = false);

  translate([9 + -hKeyDistance, 0, 0]) mirror([0, 0, 0]) union() {
    translate([2.5, 0.5, 0]) carvedArm(armL = 8, armW = 2, levelH = 0.25, firstLevelH = 0.4, levelTranslateIncrement = 7, levels = 2, drawFakeKey = false, bevel = false);
  }
  translate([9 + hKeyDistance * (keys - 1), 0, 0]) mirror([-1, 0, 0]) union() {
    translate([2.5, 0.5, 0]) carvedArm(armL = 8, armW = 2, levelH = 0.25, firstLevelH = 0.4, levelTranslateIncrement = 7, levels = 2, drawFakeKey = false, bevel = false);
  }
  for (i = [0 : -1]) for (j = [0 : keys - 2]) translate([9 + j * hKeyDistance, 0, 0]) mirror([i, 0, 0]) union() {
    if(j != numberKeyIndex - 1) translate([0, 0.25, 0]) carvedArm(armL = 8, armW = armWidth, levelH = 0.8, firstLevelH = 0.4, levelTranslateIncrement = 2, levels = 2, drawFakeKey = false, bevel = false);
  }

  translate([0, -9, 0]) numberBarSurface(keyW = topKeyW, keyD = keyD, keyH = topKeyH, keys = keys);
  echo("bar h:", keySupportH + topKeyH);
 }
}

module topRowKeysAssembly(keys = 2, rightWideKeyIndex = 0, leftWideKeyIndex = 4, keyH = 4) {
  union() {
    for (i = [0 : keys - 1]) translate([hKeyDistance * i, 0, 0]) topRowKeyAssembly(armHeight = 0.25 + i * 0.25, isRightWideKey = (i == rightWideKeyIndex ? true : false), isLeftWideKey = (i == leftWideKeyIndex ? true : false), topKeyH = keyH);
  }
}

module bottomRowKeysAssembly3(keys = 2, rightWideKeyIndex = 0, leftWideKeyIndex = 4, keyH = 5.2) {
  for (i = [0 : keys - 1]) translate([hKeyDistance * i, 0, 0]) bottomRowKeyAssembly(armHeight = 0.25 + i * 0.25, isRightWideKey = (i == rightWideKeyIndex ? true : false), isLeftWideKey = (i == leftWideKeyIndex ? true : false), keyH = keyH);
}

module carvedArm(armL, armW, levelH, firstLevelH, levelTranslateIncrement, levels, drawFakeKey = false, bevel = true) {
  union() {
    difference() {
      union() {
        keyArm(armWidth = armW, armLength = armL + 3, armHeight = firstLevelH, pivotDepth = 0);
        for(i = [1 : levels - 1]) translate([0, -(i * levelTranslateIncrement), (i - 1) * levelH + firstLevelH]) keyArm(armWidth = armW, armLength = armL + 10, armHeight = levelH, pivotDepth = 0);
      }
      translate([-armW, -armL * 11, -1]) cube([armW * 2, armL * 10, 50]);
      if (bevel) for (i = [0, -1]) mirror([i, 0, 0]) translate([-armW / 2, -armL, 0]) bevel();
    }
    if (drawFakeKey) translate([0, -armL, 0]) fakeKey(armL = armL, armW = armW);
  }
}

module fakeKey(armL, armW) {
  keyArm(armWidth = armW, armLength = 23, armHeight = 3, pivotDepth = 0);
}

module frame(keys = 6, differenceH = -1, holeIncrease = [0 , 0], frameH = 2, cutTopFrame = 2, cutBottomFrame = 0) {
  difference() {
    beveledCube([17 + hKeyDistance * keys, 79, frameH], center = false, bevelR = 8, bevelSegments = 20);
    translate([9 - holeIncrease[0] / 2, 3, differenceH]) beveledCube([-1 + hKeyDistance * keys + holeIncrease[0], 66 + holeIncrease[1], frameH * 2], center = false);
    if (cutTopFrame > 0) translate([-1,65,frameH - cutTopFrame]) cube([150,100,100]);
    else if (cutBottomFrame > 0) translate([-1,65+0.5,10]) rotate([180, 0, 0]) cube([150,100,100]);
    if (cutBottomFrame > 0) translate([-1,65+0.5,2]) rotate([20, 0, 0]) cube([150,100,100]);
  }
}

module consonantsKeyboard(keys = 5, numberKeyIndex = 2, rightWideKeyIndex = 0, leftWideKeyIndex = 4, drawTopRow = true, drawBottomRow = true, drawFrame = true, frameH = 4, keyH = 5.2, cutTopFrame = 2) {
  union() {
    if (drawTopRow) topRowKeysAssembly(keys = keys, rightWideKeyIndex = rightWideKeyIndex, leftWideKeyIndex = leftWideKeyIndex, keyH = keyH);
    if (drawBottomRow) translate([0, -10, 0]) bottomRowKeysAssembly3(keys = keys, rightWideKeyIndex = rightWideKeyIndex, leftWideKeyIndex = leftWideKeyIndex, keyH = keyH);

    if (drawFrame) translate(framePosition) difference() {
      frame(keys = keys, frameH = frameH, cutTopFrame = cutTopFrame);
      for (i = [0 : 1]) for (j = [0 : 1]) translate([5 + (25 + hKeyDistance * (keys - 1)) * i, 7 + (65) * j, -1]) cylinder(r = 3.5 / 2, h=50, $fn = 12);
      for (i = [0 : 1]) for (j = [0 : 1]) translate([5 + (25 + hKeyDistance * (keys - 1)) * i, 7 + (65) * j, 2]) cylinder(r = 7 / 2, h=50, $fn = 12);
    }
  }
}

module barKeyboard(keys = 6, numberKeyIndex = 3, rightWideKeyIndex = 0, leftWideKeyIndex = 5, drawBar = true, drawFrame = true, frameH = 4, keyH = 3.2, cutTopFrame = 0, cutBottomFrame = 3, logoH = 0.8) {
  union() {
    color("red") translate([-63.4,-239.7,3.99]) scale([1.075,1.25,1]) linear_extrude(height = logoH, center = false, convexity = 10) import(file = "stenoboardcom_logo.dxf");
    if (drawBar) numberBarAssembly(keys = keys, numberKeyIndex = numberKeyIndex, topKeyH = keyH);

    if (drawFrame) translate(framePosition) difference() {
      frame(keys = keys, frameH = frameH, cutTopFrame = cutTopFrame, cutBottomFrame = cutBottomFrame);
      for (i = [0 : 1]) for (j = [0 : 1]) translate([5 + (25 + hKeyDistance * (keys - 1)) * i, 6 + (66) * j, -1]) cylinder(r = 3.5 / 2, h=50, $fn = 12);
      for (i = [0 : 1]) for (j = [0 : 1]) translate([5 + (25 + hKeyDistance * (keys - 1)) * i, 6 + (66) * j, 2]) cylinder(r = 7 / 2, h=50, $fn = 12);
    }
  }
}

module barButtonContact() {
  beveledCube([3,6,2], bevelR = 1.5);
}

module screwHole(id, od, h, topOd, coneH, bevel = [false, false, false, false], holeStartH = -1) {
  difference() {
    union() {
      cylinder(r = od / 2, h = h - coneH);
      translate([0,0,h-coneH]) cylinder(r1 = od / 2, r2 = topOd/2, h= coneH);
      for(i = [0 : 3]) if(bevel[i]) rotate([0, 0, 45 + i * 90]) translate([od / 2- 0.5, 0, 0]) rotate([90,0,0]) bevel(r = h * 0.9, length = 1, segments = 5);
    }
    translate([0, 0, holeStartH]) cylinder(r = id / 2, h = h*3);
  }
}

module vowelsFrame(baseH = -1, frameH = 4, isKeyboard = false) {
  difference() {
    union() {
      translate([3, 7.5, 0]) beveledCube([40, 36, frameH], center = false, bevelR = 4);
      //translate([-1, 40, 0]) beveledCube([48, 1.5, frameH], center = false, bevelR = 1);
      translate([-0.5, 37.5, 0]) beveledCube([47, 8 + (isKeyboard ? 1 : 0), frameH], center = false, bevelR = 0);
    }
    translate([0, 8, 0]) if (isKeyboard) translate([7, -4, baseH]) beveledCube([32, 41 - (isKeyboard ? 2 : 0), rightVowelsScrewH * 2], center = false);
    else {
      translate([7, 2, baseH]) beveledCube([32, 50, rightVowelsScrewH * 2], center = false);
      translate([1 + 0.01, -1, frameH +0.01]) scale([1, 1.2, 1]) rotate([0, 0, 90]) rotate([-90,0,0]) bevel(r = 10, length = 100, segments = 15);
    }
    if (isKeyboard) translate([-20, -10, -1]) cube([100,50.5,100]);
  }
}

module vowelsBase(baseH) {
  union() {
    translate(rightVowelsBasePosition) difference() {
      vowelsFrame(baseH = baseH, frameH = rightVowelsScrewH + screwFrameVerticalOffset);
      for(i = [0, 1]) for(j = [1]) translate([4 + 38 * i, 6 + 37 * j, -1]) cylinder(r=rightVowelsScrewD / 2, h = 100);
    }
    for(i = [0:1]) translate(rightEReference + rightVowelsScrewPositions[i]) {
      screwHole(rightVowelsScrewD, rightVowelsScrewD + 2.5, rightVowelsScrewH - 1, rightVowelsScrewD + 2, rightVowelsScrewD + 1, rightVowelsScrewBevels[i], rightVowelsScrewH - 12);
      translate([0,4.5,rightVowelsScrewH/2]) cube([4,5,rightVowelsScrewH], center = true);
    }
    translate(rightEReference + rightVowelsScrewPositions[2]) {
      translate([0,11,rightVowelsScrewH/2]) cube([5,3,rightVowelsScrewH], center = true);
      translate([0,11,rightVowelsScrewH/4]) cube([5,8,rightVowelsScrewH/2], center = true);
    }
  }
}

module vowelsKeyboard() {
  difference() {
    union() {
      translate(rightVowelsBasePosition) vowelsFrame(isKeyboard = true);
      translate(rightEReference + [0, 9, 0]) {
        difference() {
          union() {
            bottomRowKeySurface(keyW = 13, keyD = 23, keyH = 5.2);
            translate([-3.5, 23 / 2 - 0.1, 0]) cube([7, 7,0.4]);
            translate([-3.5, 23 / 2 - 0.1 - 2, 0]) cube([7, 7,1]);
          }
          translate([-13 / 2, -23 / 2, 0,]) bevel(r = 13 / 2, length = 20, segments = 12);
          translate([13 / 2, -23 / 2, 0,]) rotate([0, 0, 90]) bevel(r = 13 / 2, length = 20, segments = 12);
        }
        translate([vowelsKeyDistance, 0, 0]) difference() {
          union() {
            bottomRowKeySurface(keyW = 13, keyD = 23, keyH = 5.2);
            translate([-3.5, 23 / 2 - 0.1, 0]) cube([7, 7,0.4]);
            translate([-3.5, 23 / 2 - 0.1 - 2, 0]) cube([7, 7,1]);
          }
          translate([-13 / 2, -23 / 2, 0,]) bevel(r = 13 / 2, length = 20, segments = 12);
          translate([13 / 2, -23 / 2, 0,]) rotate([0, 0, 90]) bevel(r = 13 / 2, length = 20, segments = 12);
        }
      }
    }
    translate(rightVowelsBasePosition) {
      for(i = [0, 1]) for(j = [0, 1]) translate([4 + 38 * i, 6 + 37 * j, -1]) cylinder(r=4 / 2, h = 100);
      translate([-2, 39, -1]) cylinder(r = 4, h = 10);
      translate([2 + 46, 39, -1]) cylinder(r = 4, h = 10);
    }
  }
}

module base(keys = 6, baseH = 1.2, baseFrameH = mainRightScrewH + screwFrameVerticalOffset, isRight = true, drawVowels = true) {
  difference() {
    union() {
      difference() {
        translate(framePosition) frame(keys, differenceH = baseH, holeIncrease = [2, 7], frameH = baseFrameH, cutTopFrame = 0);
        translate(framePosition) translate([9 - 0 / 2 + (isRight ? 0 : 64), 2, baseH + 4]) beveledCube([46, 50, baseFrameH * 2], center = false);
        if(isRight) translate([-40, -27, -1]) cube([55,26,23]);
        if(isRight) translate([-6, 10, baseFrameH]) rotate([0, 0, -90]) rotate([0, 90, 0]) cylinder(r=3.75, h = 30, center = true);
        else translate([97.3, -10, baseFrameH]) rotate([0, 0, 90]) rotate([0, 90, 0]) cylinder(r=3.75, h = 50, center = true);
        translate([-1.5 + 0.01 + (isRight ? 0 : leftVowelsOffset), -85, baseH]) cube([32 - 0.02,25,50]);
      }
      translate([5,3,12.5]) cube([15,7.2,25], center=true);
      translate([isRight ? 90 : 85,3,12.5]) cube([15,7.2,25], center=true);
      translate([isRight ? 70.5 : 20.9,-65.2,12.5]) cube([62,4,25], center=true);
      translate([isRight ? 39 : 53,-65.2,9]) cube([3,4,18], center=true);
      if (drawVowels) translate([isRight ? 0 : leftVowelsOffset, 0, 0]) vowelsBase(baseH = baseH);
      if(isRight) for(i = [0:3]) translate(boardCenter + mainRightScrewPositions[i]) screwHole(mainRightScrewD, mainRightScrewD + 2.5, mainRightScrewH, mainRightScrewD + 2, mainRightScrewD + 1, mainRightScrewBevels[i], mainRightScrewH - 12);
      else for(i = [0:3]) translate(boardCenter + mainLeftScrewPositions[i]) screwHole(mainRightScrewD, mainRightScrewD + 2.5, mainRightScrewH, mainRightScrewD + 2, mainRightScrewD + 1, mainLeftScrewBevels[i], mainRightScrewH - 12);
      if(isRight) for(i = [0:3]) translate(boardCenter + arduinoScrewOffset + arduinoScrewPositions[i]) screwHole(arduinoScrewD, arduinoScrewD + 6, arduinoScrewH, arduinoScrewD + 2, arduinoScrewD + 1);
      %translate(boardCenter + arduinoScrewOffset + arduinoScrewPositions[0] + [-15.3, 2.5 - 53.3, arduinoScrewH]) cube([68.6, 53.3, 1.4]);
    }
    for(i = [0:3]) translate(frameScrewPositions[i] + [0, 0, -1]) cylinder(r = frameScrewD / 2, h = 100);
  }
}

module rightBaseBridgeTest() {
  intersection() {
    base(drawVowels = true);
    translate([-20,-37, 18]) cube([12, 47, 7]);
  }
}