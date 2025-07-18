# ipelet-measurement

#### Ipelet (extension to Ipe extensible drawing editor) Measurement for polyline lengths and angles measurement

This is an ipelet for [Ipe](https://ipe.otfried.org/) which enables you to measure distances and angles (select: `Ipelets→Measurement→Measure distances and angles`). Meanwhile it works only if the primary selection is a polyline or other polygonal path. The length unit can be set by creating a line of desired unit length (typically using the predefined grid) and then selecting `Ipelets→Measurement→Set unit`. Otherwise, points are used as a default unit.

Distances can be displayed as labels (dimensions) to the right, left, below or above the respective line segments (select: `Ipelets→Measurement→Mark distances WHERE`, where `WHERE` is either right, left, below or above).

Any tips, bug reports, feature requests and other contributions are welcome.

This ipelet structure was inspired by [Ipelets by Günter Rote](https://www.mi.fu-berlin.de/inf/groups/ag-ti/software/ipelets.html).

## Installation

Copy `measurement.lua` to folder `ipelets` which is in the folder where Ipe is installed.
