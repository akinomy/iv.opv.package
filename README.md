
This package contains functions for generating i-v summaries and plots from raw i-v characteristics of (organic) photovoltaics. 

The main function ```iv.summary(data_dir, output_dir, pattern = "")``` analyses all files containing i-v characteristics and calculates the solar cells parameters (Isc, Voc, FF, efficiency, resistivity) matching given ```pattern```.

Install a package directly from the GitHub page.
```r
library(devtools)
install_github('akinomy/PhotoVoltaicsChar')
```

#### Example
Example of using ```iv.summary(data_dir, output_dir, pattern = "")``` function.

The collected current-voltage characteristic is assumed to have a `.dat` extension and each such file should contain two columns (voltage, series1).
```r
voltage	series1	
0	-0.2299582
0.0275	-0.2265189
0.055	-0.2240239
0.083	-0.2205034
````

`data_dir` can contain many such files and specific groups of files can be selected for analysis with by specifying a pattern in the file name via the pattern option (e.g. `pattern="pixel"` or `pattern="device"`)

After running  ```r iv.summary(data_dir, output_dir, pattern = "")```

the output folder  `output_dir will` contain `Summary_efficiency.dat` and a `fig` subdirectory where all the auxiliary figures will be stored.

The file `Summary_efficiency.dat` contains summary characteristics from each processed `.dat` file
```r
                         data//S2500_og1_pixe1_01.dat data//S2500_og1_pixe2_01.dat data//S2500_og1_pixe3_01.dat
I_sc (mA/cm^2)                    -3.8326367                   -4.5021650                   -4.5546300
V_oc (V)                           0.5304575                    0.5315812                    0.5033092
FF(%)                             49.8678364                   49.1958129                   39.2810589
P_max (mW/cm^2)                    1.0138385                    1.1773867                    0.9004739
Efficiency (%)                     1.0138385                    1.1773867                    0.9004739
r_s                               15.6381889                   14.0442675                   17.4861618
```
Additionally, in catalog ```output_dir/fig``` there are plots of current-voltage characteristics.


