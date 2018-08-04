#' Summary of solar cells characteristics
#'
#' Given an input directory `data_dir` the function looks for `.dat` files matching `patern`
#' and uses them to calculate and plot i-v characterisitcs
#' @param data_dir input directory
#' @param output_dir output directory
#' @param pattern which files to select
#' @return data frame containing i-v summary (Isc, Voc, FF, efficiency, resistivity)
#' @keywords i-v curve, solar cell parameters
#' @export

iv.summary <-function(data_dir, output_dir, pattern="") {
  names=list.files(data_dir, pattern=pattern, full.names = TRUE)

  fig_dir = file.path(output_dir, "fig")
  if (! dir.exists(fig_dir)){
    dir.create(fig_dir)
  }

  extract_data<-function(name){
    output_file = file.path(fig_dir, paste(basename(name),".png"))
    charakterystyki(name, output_file)
  }

  efficiency_summary=sapply(names, extract_data)
  efficiency_summary = as.data.frame(efficiency_summary )
  write.table(efficiency_summary,  file.path(output_dir, "Summary_efficiency.dat"))
  return(efficiency_summary)
}


charakterystyki <-function(input_file, output_file) {
  data=current.per.area(input_file)
  png(output_file)
  iv.plot(data)
  dev.off()

  results=PVparameters(data)
  return(results)
}


current.per.area <-function(nazwa, S_elektrody=0.06) {
  print(nazwa)
  dane=read.table(nazwa,header=TRUE)
  dane$current_na_cm2=dane$series1/S_elektrody
  return(dane)
}


#' Solar cell parameters
#'
#' For a given current - voltage data this function calculates the maximal power (Pmax) using interpolation,
#' efficiency, short current denisty (I_sc), open circuit voltage (V_oc), FF factor, resistivity
#' @param  dane data table with `voltage` and `current_na_cm2`
#' @return vector containing i-v summary (Isc, Voc, FF, efficiency, resistivity)
#' @keywords solar cell parameters
#' @export

PVparameters<-function(dane){
  P=dane$voltage*dane$current_na_cm2

  pr=splinefun(x=dane$voltage, y=dane$voltage*dane$current_na_cm2)
  x=dane$Voltage
  res=optimize(f=pr, interval=c(-0.2,1))

  P_max=abs(res$objective)
  P_in=100
  efficiency=P_max/P_in*100
  I_sc=dane$current_na_cm2[dane$voltage==0]

  # Open-circuit Voltage V_oc - based on linear regression
  V_1=max(dane$voltage[dane$current_na_cm2<0])
  I_1=max(dane$current_na_cm2[dane$voltage==V_1])

  V_2=min(dane$voltage[dane$current_na_cm2 >0])
  I_2=min(dane$current_na_cm2[dane$voltage==V_2])

  V_oc=(I_1*V_2-I_2*V_1)/(I_1-I_2)

  # Factor FF
  FF=P_max/(abs(I_sc)*V_oc)*100

  # Resistivity - # Ohm*cm2
  pochodna = diff( dane$current_na_cm2)/diff(dane$voltage) # mA/cm2 /V

  # remove the last row in order to split with pochodna
  dane = dane[-nrow(dane),]
  dane$pochodna = pochodna

  which_Isc_zero = which(dane$voltage==min(dane$voltage[dane$series1 >0]))
  r_s = 1/(pochodna[which_Isc_zero]*0.001)
  r_sh = 1/(pochodna[1]*0.001) # V/A


  # Results
  results_summary=c(
    "I_sc (mA/cm^2)"=I_sc,
    "V_oc (V)"=V_oc,
    "FF(%)"=FF,
    "P_max (mW/cm^2)"=P_max,
    "Efficiency (%)"=efficiency,
    "r_s" = r_s,
    "r_sh" =r_sh)
  return(results_summary)
}


#' I-V curve Function
#'
#' This funcion draws the current-voltage charasteristic
#' @param dane data table with `voltage` and `current_na_cm2`
#' @keywords i-v curve
#' @return plot of i-v characteristic
#' @export

iv.plot <-function(dane) {
  wyniki=PVparameters(dane)
  plot_i_v=plot(
    x=dane$voltage, y=dane$current_na_cm2,
    xlab="Voltage (V)", ylab=expression("Current density" (mA/cm^2)),
    text(0.2,max(dane$current_na_cm2),substitute("Efficiency(%)"==I, list(I=wyniki[5]))))

  abline(h=0)
  return(plot_i_v)
}
