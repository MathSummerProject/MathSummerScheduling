library(dplyr)
library(survival)

#par(mfrow=c(1,2))

su1 <- read.csv("/Users/linni/Documents/MATH 381/su1.csv", header = TRUE)
su1 <- data.frame(su1)

m111 <- su1[su1$Crs.No == 111,]
m111 <- m111[m111$Current.Enrlmnt != 0,]
summary(m111)

t_at <- c(110, 220, 940, 1050, 1200)
yr_at <- 2008:2018
t_ex <- expression(paste(1,":",10,"pm"), paste(2,":",20,"pm"), 
                   paste(9,":",40,"am"), paste(10,":",50,"am"),
                   paste(12,":00","am"))
defa <- rep(0, length(t_at))

graph1 <- function(course) {
  bf <- data.frame("Section" = t_at, "> 0.8 LB" = defa,
                   "> 0.8 UB" = defa, "0.57~0.8 LB"= defa,
                   "0.57~0.8 UB" = defa,
                   "< 0.57 LB" = defa,
                   "< 0.57 UB" = defa)
  names(bf)<-c("Section","> 0.8 LB","> 0.8 UB",
               "0.57~0.8 LB","0.57~0.8 UB",
               "< 0.57 LB","< 0.57 UB")
  par(mfrow=c(2,3))
  mc <- su1[su1$Crs.No == course,]
  mc <- mc[mc$Current.Enrlmnt != 0,]
  p<-numeric(11)
  for (i in 1:11) {
    yr <- mc[mc$Yr == yr_at[i],]
    p[i] <- nrow(yr)
  }

  plot(yr_at, p, main=paste("MATH",course),
       xlab="Year",ylab="Section Number", pch=20)
  
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
      total = total + e_yr * p[a]
    }
    mu<-total/(sum(p))
    ntrial<-1000
    x<-numeric(ntrial)
    k1 <- 0
    k2 <- 0
    k3 <- 0
    for (j in 1:ntrial){
      d <- rpois(occur, mu)
      x[j] <- mean(d)/40
      if (x[j] > 0.8) {
        k1 = k1 + 1
      } else if (x[j] <= 0.8 && x[j] >= 0.57) {
        k2 = k2 + 1
      } else { #x[j] < 0.57
        k3 = k3 + 1
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
    
    bf[bf$Section==i,]$"< 0.57 LB" = 
      cipoisson(k3,time=1000,p=0.95)[1]
    bf[bf$Section==i,]$"< 0.57 UB" = 
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
  return(bf)
}

graph1(111)


priority <- function(course) {
  bf <- graph1(course)
  bf <- bf[order(-bf$`> 0.8 LB`,
                 -bf$`0.57~0.8 LB`,
                 -bf$`< 0.57 LB`),]
  print("current priority: ")
  print(bf$Section)
  return(bf)
}
priority(308)


count
solution <- function(course) {
  crsN <- read.csv("/Users/linni/Documents/MATH 381/crsN.csv", header = TRUE)
  crsN <- data.frame(crsN)
  count <- crsN[crsN$Course==111,][2]
  num <- crsN[crsN$Course==course,][2]
  q <- priority(course)
  sol <- data.frame("Section" = t_at, "Nmuber" = defa)
  now<-0
  while (now < num) {

    sec <- q$"Section"[1]
    if (q[q$`Section`==sec,]$`0.57~0.8 UB` < 0.29 && 
        sol[sol$"Section"==220,]$"Nmuber" == 0) {
      sec = 220
    }
    now = now + 1
    
    sol[sol$"Section"==sec,]$"Nmuber" = sol[sol$"Section"==sec,]$"Nmuber" + 1
    
    if (sol[sol$"Section"==sec,]$"Nmuber" == as.integer(num / 2)) {
      q[q$`Section`==sec,]$`> 0.8 LB` = 0
      q[q$`Section`==sec,]$`> 0.8 UB` = 0
      q[q$`Section`==sec,]$`0.57~0.8 LB` = 0
      q[q$`Section`==sec,]$`0.57~0.8 UB` = 0
      q[q$`Section`==sec,]$`< 0.57 LB` = 0
      q[q$`Section`==sec,]$`< 0.57 UB` = 0
    }
    
    q[q$`Section`==sec,]$`> 0.8 LB` = q[q$`Section`==sec,]$`> 0.8 LB` / 2
    q[q$`Section`==sec,]$`> 0.8 UB` = q[q$`Section`==sec,]$`> 0.8 UB` / 2
    q[q$`Section`==sec,]$`0.57~0.8 LB` = q[q$`Section`==sec,]$`0.57~0.8 LB` / 2
    q[q$`Section`==sec,]$`0.57~0.8 UB` = q[q$`Section`==sec,]$`0.57~0.8 UB` / 2
    q[q$`Section`==sec,]$`< 0.57 LB` = q[q$`Section`==sec,]$`< 0.57 LB` / 2
    q[q$`Section`==sec,]$`< 0.57 UB` = q[q$`Section`==sec,]$`< 0.57 UB` / 2
    
    q <- q[order(-q$`> 0.8 LB`),]
    sec <- q$"Section"[1]
    if (q[q$`Section`==sec,]$`> 0.8 LB` < 0.29) {
      q <- q[order(-q$`0.57~0.8 LB`),]
    }
  }
  return(sol)
}
solution(324)

course = c(111, 120, 124, 125, 126, 307, 308, 309, 324)

sink("/Users/linni/Documents/MATH 381/output.txt")

for (i in course) {
  print(i)
  print(solution(i))
}

sink()


aa




bf[bf$Section==i,]$"< 0.57 UB" = 
      cipoisson(k2,time=1000,p=0.95)[2]



lst[order(unlist(lst),decreasing=TRUE)]


?order
q <- PriorityQueue$new()
q$push(2,4)
q$push(2,3)
print(q)
  
mu940<-mean(start_940$Predicted.Enrlmnt)
mu940
ntrial<-10000
x<-numeric(ntrial)
occur <- nrow(start_940)
for (i in 1:ntrial){
  d <- rpois(occur, mu940)
  x[i] <- mean(d)/40
}
hist(x,main=paste("Start Time 9:40","occur:", occur),
     xlab="Predicted Enrolmnt",
     xlim=c(0,1))
abline(v=0.29,col='green')
abline(v=0.57,col='blue')
abline(v=0.80,col='red')
text(0.29,1000, "0.29", pos = 2)
text(0.57, 1000, "0.57", pos = 2)
text(0.8,1000, "0.80", pos = 4)


mu1050<-mean(start_1050$Predicted.Enrlmnt)
mu1050
ntrial<-10000
x<-numeric(ntrial)
occur <- nrow(start_1050)
for (i in 1:ntrial){
  d <- rpois(occur, mu1050)
  x[i] <- mean(d)/40
}
hist(x,main=paste("Start Time 10:50","occur:", occur),
     xlab="Predicted Enrolmnt",
     xlim=c(0,1))
abline(v=0.29,col='green')
abline(v=0.57,col='blue')
abline(v=0.80,col='red')
text(0.29,1000, "0.29", pos = 2)
text(0.57, 1000, "0.57", pos = 2)
text(0.8,1000, "0.80", pos = 4)



summary(x)

par(mfrow=c(2,3))
#t_at <- c(110, 220, 940, 1050, 1200)
for (j in t_at) {
  x<-numeric(ntrial)
  m<-su1[su1$Start.Time==j,]
  occur<-nrow(m)
  mu <- mean(su1$Predicted.Enrlmnt)
  for (i in 1:ntrial){
    d <- rpois(occur, mu)
    x[i] <- mean(d)/40
  }
  hist(x,main=paste("Start Time",j,"occur:", occur),
       xlab="Predicted Enrolmnt",
       xlim=c(0,1))
  abline(v=0.29,col='green')
  abline(v=0.57,col='blue')
  abline(v=0.80,col='red')
  text(0.29,1000, "0.29", pos = 2)
  text(0.57, 1000, "0.57", pos = 2)
  text(0.8,1000, "0.80", pos = 4)
}



d111 = read.csv("/Users/linni/Documents/MATH 381/111.csv", header = TRUE)
head(d111)
d111<-data.frame(d111)

d120 = read.csv("/Users/linni/Documents/MATH 381/120.csv", header = TRUE)
head(d120)
d120<-data.frame(d120)

math = read.csv("/Users/linni/Documents/MATH 381/su2.csv", header = TRUE)
head(math)
names(math)
math[math$Crs.No == 111]

course = c(111, 120, 124, 125, 126, 307, 308, 309, 324)
course[1]

par(mfrow=c(3,3))
for (i in 1:9) {
  #jpeg(file = paste(course[j], '.jpeg', sep = ''))
    df1 <- math[math$Crs.No == course[i],]
    plot(df1$Yr,df1$Percentageof.Enrollment,
         xlab="Year", ylab="Enrollment Percentage",ylim=c(0,105),
         main=paste ("MATH", course[i],sep = " "),xaxt="n")
    abline(h=57,col='red',ylab=57)
    abline(h=80,col='red')
    axis(1,at=seq(2008,2018,by=1),las=2)
  #dev.off()
}
5:5
par(mfrow=c(3,3))

su3 = read.csv("/Users/linni/Documents/MATH 381/su3.csv", header = TRUE)
su3<-data.frame(su3)
d<-su3[su3$Crs.No == 111,]
d<-d[d$Yr == 2008,]
length(d$Section[!is.na(d$Section)])

sink("output.txt", type="output")
for (i in 1:9) {
  df1 <- su3[su3$Crs.No == course[i],]
  for (j in 2008:2018) {
    df2 <- df1[df1$Yr == j,]
    writeLines(paste(course[i],j,length(df2$Section[!is.na(df2$Section)]),sep = " "))
  }
}
sink()

par(mfrow=c(3,3))
for (i in 1:9) {
  df1 <- math[math$Crs.No == course[i],]
  hist(df1$Percentageof.Enrollment, 
       main=paste("MATH", course[i], "Enrollment Percentage"),
       xlab="Enrollment Percentage")
}

hist(Percentageof.Enrollment, main="MATH 120 Enrollment Percentage",
     xlim=c(0,105),ylim=c(0,8),breaks=seq(0,105,by=15))
print(length(df1$Section))

for (i in 1:9) {
  df1 <- math[math$Crs.No == course[i],]

    df2 <- df1[df1$Yr == j,]
    plot(df1$Yr,df1$Start.Time,
         xlab="Year", ylab="Start Time", ylim=c(110,1200),
         main=paste ("MATH", course[i],sep = " "),xaxt="n",pch=4)
    axis(1,at=seq(2008,2018,by=1),las=2)
    axis(1, at = c(110, 220, 940, 1050, 1200),
         labels = expression(paste(1,":",10,"pm"), paste(2,":",20,"pm"), 
                             paste(9,":",40,"am"), paste(10,":",50,"am"),
                             paste(12,":00","am")))

}



for (i in 1:9) {
  df1 <- math[math$Crs.No == course[i],]
  for (j in 2008:2018) {
    df2 <- df1[df1$Yr == j,]
    plot(j,length(df2$Section[!is.na(df2$Section)]),
         xlab="Year", ylab="Section Number",
         main=paste ("MATH", course[i],sep = " "))
  }
}


par(mfrow=c(3,3))
for (i in 1:9) {
  df1 <- math[math$Crs.No == course[i],]
  plot(df1$Start.Time,df1$Percentageof.Enrollment,
       xlab="Start Time", ylab="Enrollment Percentage", ylim=c(0,105),
       main=paste ("MATH", course[i],sep = " "),xaxt="n")
  axis(1, at = c(110, 220, 940, 1050, 1200),
       labels = expression(paste(1,":",10,"pm"), paste(2,":",20,"pm"), 
                           paste(9,":",40,"am"), paste(10,":",50,"am"),
                           paste(12,":00","am")))
  abline(h=57,col='red',ylab=57)
  abline(h=80,col='red')
}

c(1,"year")

sec = c("A","B","C")
for (i in 1:9) {
  #jpeg(file = paste(course[j], '.jpeg', sep = ''))
  df1 <- math[math$Crs.No == course[i],]
  for (j in 1:3) {
    #jpeg(file = paste(course[j], '.jpeg', sep = ''))
    df2 <- df1[math$Section == sec[j],]
    print(mean(df2$Percentageof.Enrollment))
  }
}


math<-data.frame(math)
math$Start.Time

par(mfrow=c(1,1))
plot(math$Yr,math$Percentageof.Enrollment,
     xlab="Year", ylab="Enrollment Percentage")

plot(math$Yr,math$Start.Time,
     xlab="Year", ylab="Start Time")

plot(math$Start.Time,math$Percentageof.Enrollment,
     xlab="Start Time", ylab="Enrollment Percentage",
     xlim=c(0,1200),xaxt="n", main="")
axis(1, at = c(110, 220, 940, 1050, 1200),
     labels = expression(paste(1,":",10,"pm"), paste(2,":",20,"pm"), 
                         paste(9,":",40,"am"), paste(10,":",50,"am"),
                         paste(12,":00","am")))
abline(h=57,col='red',ylab=57)
abline(h=80,col='red')






