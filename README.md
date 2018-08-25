### Current-voltage analysis
Functions used to analyse current-voltage (i-v) characteristic of organic solar cells. 
* Input: textfile contained measured i-v paired
* Output: data frame containing i-v summary (Isc, Voc, FF, efficiency, resistivity)

The main function iv.summary(data_dir, output_dir, pattern = "") analyses all matchig files containing i-v characteristics and calculates the solar cells paramaterers (Isc, Voc, FF, efficiency, resistivity)

#### Example
Example of using iv.summary(data_dir, output_dir, pattern = "") function.

1. The collected current-voltage characteristic is saved in .dat format. The file contains two columns (voltage, series1). 
```r
voltage	series1	
0	-0.2299582
0.0275	-0.2265189
0.055	-0.2240239
0.083	-0.2205034
````
2. All files are saved in common folder e.g. (data_dir) and have common names' pattern (e.g. "pixel", "device", ...) 
3. The analysis will be saved as "Summary_efficiency.dat" in output_dir file

```r
iv.summary(data_dir, output_dir, pattern = "pixel")

                         data//S2500_og1_pixe1_01.dat data//S2500_og1_pixe2_01.dat data//S2500_og1_pixe3_01.dat
I_sc (mA/cm^2)                    -3.8326367                   -4.5021650                   -4.5546300
V_oc (V)                           0.5304575                    0.5315812                    0.5033092
FF(%)                             49.8678364                   49.1958129                   39.2810589
P_max (mW/cm^2)                    1.0138385                    1.1773867                    0.9004739
Efficiency (%)                     1.0138385                    1.1773867                    0.9004739
r_s                               15.6381889                   14.0442675                   17.4861618
```



