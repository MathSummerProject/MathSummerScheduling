library(dplyr)
library(survival)
# need to run initial first to get all initial field

initial <- function() {
  t_at <- c(110, 220, 940, 1050, 1200)
  yr_at <- 2008:2018
  course = c(111, 120, 124, 125, 126, 307, 308, 309, 324)
  weight <- c(seq(0.1,0.6,0.1), seq(0.8, 1.6, 0.2))
  weight <- weight / sum(weight)
  
  su1 <- read.csv("/Users/linni/Documents/MATH 381/su1.csv", header = TRUE)
  su1 <- data.frame(su1)
  
  # m111 <- su1[su1$Crs.No == 111,]
  # m111 <- m111[m111$Current.Enrlmnt != 0,]
  # summary(m111)
  
  t_ex <- expression(paste(1,":",10,"pm"), paste(2,":",20,"pm"), 
                     paste(9,":",40,"am"), paste(10,":",50,"am"),
                     paste(12,":00","am"))
  defa <- rep(0, length(t_at))

  stu<-numeric(11)
  for (i in yr_at) {
    stu[i-2007] <- sum(su1[su1$Yr == i,]$Current.Enrlmnt)
  }
  plot(yr_at, stu,
       main=paste("MATH Course Total Enrollment"), 
       ylim=c(0,max(stu)+10),
       xlab="Year",ylab="Total Enrollment", pch=20)
}

graph <- function(course) {
  initial()
  png(paste(course,".png"))
  par(mfrow=c(3,3))
  
  bf <- data.frame("Section" = t_at, "> 0.8 LB" = defa,
                   "> 0.8 UB" = defa, "0.57~0.8 LB"= defa,
                   "0.57~0.8 UB" = defa,
                   "> 0.57 LB" = defa,
                   "> 0.57 UB" = defa)
  names(bf)<-c("Section","> 0.8 LB","> 0.8 UB",
               "0.57~0.8 LB","0.57~0.8 UB",
               "> 0.57 LB","> 0.57 UB")
  
  mc <- su1[su1$Crs.No == course,]
  mc <- mc[mc$Current.Enrlmnt != 0,]
  p<-numeric(11)
  stu<-numeric(11)
  for (i in 1:11) {
    yr <- mc[mc$Yr == yr_at[i],]
    p[i] <- as.integer(nrow(yr))
    stu[i] <- sum(yr$Current.Enrlmnt)
  }
  plot(yr_at, stu,
       main=paste("MATH",course), ylim=c(0,max(stu)+10),
       xlab="Year",ylab="Total Enrollment", pch=20)

  plot(yr_at, p, main=paste("MATH",course),
       xlab="Year",ylab="Section Number",
       ylim=c(0,max(p)+1),pch=20)
  
  mc$pch=20
  mc$pch[mc$Yr>=2015]=4
  mc$Color="black"
  mc$Color[mc$Yr>=2015]="red"
  plot(mc$Start.Time,mc$Enrlmnt.Percentage,
       main=paste("MATH",course),xlab="Start Time", 
       ylab="Enrollment Percentage",xaxt="n",
       ylim=c(0,1), pch=mc$pch, col=mc$Color)
  axis(1, at = t_at,labels = t_ex)
  abline(h=0.29,col='green')
  abline(h=0.57,col='blue')
  abline(h=0.80,col='red')
  #text(400, 0.29, "0.29", pos = 4)
  #text(400, 0.57, "0.57", pos = 4)
  #text(400, 0.8, "0.80", pos = 4)
  hist(mc$Start.Time, main=paste("MATH",course), 
       xlab="Start Time",xaxt="n")
  axis(1, at = t_at,labels = t_ex)

  count <- 0
  for (i in t_at) {
    
    sec <- mc[mc$Start.Time == i,]
    occur <- nrow(sec)
    if (occur == 0) {next}
    count = count+1
    total <- 0
    #sec_tot <- 0
    for (a in 1:11) {
      sec_e <- sec[sec$Yr == yr_at[a],]
      e_yr <- sec_e$Predicted.Enrlmnt
      if (length(e_yr)==0) {e_yr = 0}
      total = total + e_yr * p[a] * weight[a]
    }
    
    mu<-total/(sum(p*weight))

    ntrial<-1000
    x<-numeric(ntrial)
    k1 <- 0
    k2 <- 0
    k3 <- 0
    for (j in 1:ntrial){
      d <- rpois(occur, mu)
      x[j] <- mean(d)/40
      if (x[j] >= 0.57) {
        k3 = k3 + 1
        if (x[j] > 0.8) {
          k1 = k1 + 1
        } else { # (x[j] <= 0.8 && x[j] >= 0.57
          k2 = k2 + 1
        }
      }
    }
    
    bf[bf$Section==i,]$"> 0.8 LB" = 
      cipoisson(k1,time=1000,p=0.95)[1]
    bf[bf$Section==i,]$"> 0.8 UB" = 
      cipoisson(k1,time=1000,p=0.95)[2]
    
    bf[bf$Section==i,]$"0.57~0.8 LB" = 
      cipoisson(k2,time=1000,p=0.95)[1]
    bf[bf$Section==i,]$"0.57~0.8 UB" = 
      cipoisson(k2,time=1000,p=0.95)[2]
    
    bf[bf$Section==i,]$"> 0.57 LB" = 
      cipoisson(k3,time=1000,p=0.95)[1]
    bf[bf$Section==i,]$"> 0.57 UB" = 
      cipoisson(k3,time=1000,p=0.95)[2]
    
    hist(x,main=paste("Start Time", i, "occur:", occur),
         xlab="Predicted Enrolmnt",
         xlim=c(0,1))
    abline(v=0.29,col='green')
    abline(v=0.57,col='blue')
    abline(v=0.80,col='red')
    text(0.29,1000, "0.29", pos = 2)
    text(0.57, 1000, "0.57", pos = 2)
    text(0.8,1000, "0.80", pos = 4)
  }
  dev.off()
  return(bf)
}

priority <- function(course) {
  bf <- graph(course)
  bf <- bf[order(-bf$`> 0.8 LB`,
                 -bf$`0.57~0.8 LB`,
                 -bf$`> 0.57 LB`),]
  
  for (i in t_at) {
    m <- bf[bf$Section == i,]
    num <- which(bf$Section == i)
    
    if (m$`> 0.57 LB` < 0.57) {
      bf<-bf[-num,]
    }
  }
  print("performance:")
  print(bf)
  return(bf)
}

solution <- function(course) {

  crsN <- read.csv("/Users/linni/Documents/MATH 381/crsN.csv", header = TRUE)
  crsN <- data.frame(crsN)
  num <- crsN[crsN$Course==course,]$Number
  q <- priority(course)
  sol <- data.frame("Section" = t_at, "Nmuber" = defa)
  now<-0
  while (now < num) {
    
    nonRep <- min(nrow(q),num-now)
    for (i in 1:nonRep) {
      sol[sol$"Section"==q$Section[i],]$"Nmuber" = 
        sol[sol$"Section"==q$Section[i],]$"Nmuber" + 1
      now <- now + 1
    }
    
    if (now < num) {
      sol[sol$"Section"==220,]$"Nmuber" = 
        sol[sol$"Section"==220,]$"Nmuber" + 1
      now <- now + 1

    }
  }
  cat('\n')
  return(sol)
}

produce <- function() {
  sink("/Users/linni/Documents/MATH 381/output.txt")
  course = c(111, 120, 124, 125, 126, 307, 308, 309, 324)
  for (i in course) {
    print(i)
    print(solution(i))
    cat('\n\n')
  }
  sink()
}

produce()

