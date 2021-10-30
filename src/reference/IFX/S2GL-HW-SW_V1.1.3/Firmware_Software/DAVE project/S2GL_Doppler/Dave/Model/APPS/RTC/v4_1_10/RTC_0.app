<?xml version="1.0" encoding="ASCII"?>
<ResourceModel:App xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ResourceModel="http://www.infineon.com/Davex/Resource.ecore" name="RTC" URI="http://resources/4.1.10/app/RTC/0" description="Provides timing and alarm functions using RTC in the calendar time format." version="4.1.10" minDaveVersion="4.0.0" instanceLabel="RTC_0" appLabel="">
  <properties singleton="true" provideInit="true" sharable="true"/>
  <requiredApps URI="http://resources/4.1.10/app/RTC/0/appres_clk_xmc1" requiredAppName="CLOCK_XMC1" requiringMode="SHARABLE">
    <downwardMapList xsi:type="ResourceModel:App" href="../../CLOCK_XMC1/v4_0_14/CLOCK_XMC1_0.app#/"/>
  </requiredApps>
  <requiredApps URI="http://resources/4.1.10/app/RTC/0/appres_global_scu" requiredAppName="GLOBAL_SCU_XMC1" requiringMode="SHARABLE">
    <downwardMapList xsi:type="ResourceModel:App" href="../../GLOBAL_SCU_XMC1/v4_1_6/GLOBAL_SCU_XMC1_0.app#/"/>
  </requiredApps>
</ResourceModel:App>
