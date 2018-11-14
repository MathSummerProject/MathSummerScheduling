library(dplyr)
par(mfrow=c(1,2))

d111 = read.csv("/Users/linni/Documents/MATH 381/111.csv", header = TRUE)
head(d111)
d111<-data.frame(d111)

d120 = read.csv("/Users/linni/Documents/MATH 381/120.csv", header = TRUE)
head(d120)
d120<-data.frame(d120)

math = read.csv("/Users/linni/Documents/MATH 381/su2.csv", header = TRUE)
head(math)
names(math)
math<-data.frame(math)
math$Start.Time
plot(math$Start.Time,math$Percentageof.Enrollment,
     xlab="Start Time", ylab="Enrollment Percentage",
     xlim=c(0,1200))

 plot(d111$Yr,d111$Percentageof.Enrollment,xlab="Year",
     ylab="Enrollment Percentage",
     xlim=c(2008,2018),ylim=c(0,105),xaxt="n",
     main="MATH 111 Enrollment Percentage")
axis(1,at=seq(2008,2018,by=1),las=2)
abline(h=57,col='red',ylab=57)
abline(h=80,col='red')

plot(d120$Yr,d120$Percentageof.Enrollment,xlab="Year",
     ylab="Enrollment Percentage",
     xlim=c(2008,2018),,ylim=c(0,105),xaxt="n",
     main="MATH 120 Enrollment Percentage")
axis(1,at=seq(2008,2018,by=1),las=2)
abline(h=57,col='red')
abline(h=80,col='red')
library(dplyr)

plot(length(d111$Section),d111$Percentageof.Enrollment,xlab="Year",
     ylab="Enrollment Percentage",
     xlim=c(2008,2018),ylim=c(0,105),xaxt="n",
     main="MATH 111 Enrollment Percentage")

plot()

axis(1,at=seq(2008,2018,by=1),las=2)
abline(h=57,col='red',ylab=57)
abline(h=80,col='red')

plot(d120$Yr,d120$Percentageof.Enrollment,xlab="Year",
     ylab="Enrollment Percentage",
     xlim=c(2008,2018),,ylim=c(0,105),xaxt="n",
     main="MATH 120 Enrollment Percentage")
axis(1,at=seq(2008,2018,by=1),las=2)
abline(h=57,col='red')
abline(h=80,col='red')


d111 %>%
  group_by(Yr) %>%
  count(Yr) %>%
  group_by(n) %>%
  filter(n==1) %>%
  summarise(totalCE=sum(Current.Enrlmnt),
            totalEE=sum(Limit.Est.Enrlmnt),
            ave=sum(Current.Enrlmnt)/sum(Limit.Est.Enrlmnt))
     
d111 %>%
  group_by(Yr) %>%
  count(Yr) %>%
  group_by(n) %>%
  filter(n=2) 
%>%
  summarise(totalCE=sum(Current.Enrlmnt),
            totalEE=sum(Limit.Est.Enrlmnt),
            ave=sum(Current.Enrlmnt)/sum(Limit.Est.Enrlmnt))       

d120 %>%
  count(Yr) %>%
  group_by(n) %>%
  mutate(totalCE=sum(Current.Enrlmnt[which(n==1)]),
         totalEE=sum(Limit.Est.Enrlmnt[which(n==1)]),
         ave=totalCE/totalEE)


d120 %>%
  count(Yr) %>%
  group_by(n) %>%
  mutate(totalCE=sum(Current.Enrlmnt[which(n==2)]))

d120 %>%
  count(Yr) %>%
  mutate(d120,n)
      
d120


  summarise(totalCE=sum(Current.Enrlmnt[which(n==3)]),
            totalEE=sum(Limit.Est.Enrlmnt[which(n==3)]),
            ave=totalCE/totalEE)



  
  
  

d120 %>%
  group_by(Section) %>%
  summarise(ave=sum(Current.Enrlmnt)/sum(Limit.Est.Enrlmnt))

hist(Yr, freq=Percentageof.Enrollment,main="MATH 111 Enrollment Percentage",
     breaks=seq(2008,2016,by=1),xlim=c(2008,2016))

plot(d111$Yr,d111$Percentageof.Enrollment,xlab="Year",ylab="Enrollment Percentage",
     xlim=c(2008,2018),xaxt="n",main="MATH 111 Enrollment Percentage")
axis(1,at=seq(2008,2018,by=1),las=2)
abline(h=57,col='red')
abline(h=80,col='red')

plot(d120$Yr,d120$Percentageof.Enrollment,xlab="Year",ylab="Enrollment Percentage",
     xlim=c(2008,2018),xaxt="n",main="MATH 120 Enrollment Percentage")
axis(1,at=seq(2008,2018,by=1),las=2)
abline(h=57,col='red')
abline(h=80,col='red')

?abline
d120 = read.csv("/Users/linni/Documents/MATH 381/120.csv", header = TRUE)
head(d120)
d120<-data.frame(d120)


hist(Percentageof.Enrollment, main="MATH 120 Enrollment Percentage",
     xlim=c(0,105),ylim=c(0,8),breaks=seq(0,105,by=15))

hist()

par(mfrow=c(1,1))
boxplot(d111$Percentageof.Enrollment,d120$Percentageof.Enrollment, 
        names=c("MATH 111", "MATH 120"), 
        main="MATH 111&120 Enrollment Percentage comparison",
        ylab="Enrollment Percentage")

N<-100
simx<-runif(N,0,1)
simy<-runif(N,0,1)

mean(simx>simy)
mean(simx[simx>simy])
sum(simx[simx>simy]>0.5)

 mean(simx2)
mean(simy2)
plot(simx2,simy2)


T1 <- table(1:10 > 5, 11:20 > 17)
Q14 <- T1["TRUE","TRUE"]
Q14
Q15<-T1["TRUE",]
Q15
