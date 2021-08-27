function ss = f2(theta,data)

time   = data.ydata(:,1);%modeling time period
ydata  = data.ydata(:,2:size(data.ydata,2));%observed data
xdata  = data.xdata;
ymodel = f3(time,theta,xdata);%model results
ss =sum((sqrt(ymodel) - sqrt(ydata)).^2);%sum-of-squares function
