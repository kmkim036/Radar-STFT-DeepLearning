<?xml version="1.0" encoding="ASCII"?>
<ResourceModel:App xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ResourceModel="http://www.infineon.com/Davex/Resource.ecore" name="GLOBAL_SCU_XMC1" URI="http://resources/4.1.6/app/GLOBAL_SCU_XMC1/0" description="GLOBAL_SCU_XMC1 APP allows to register callback functions and to handle the SR0/SR1/SR2 service request Events." version="4.1.6" minDaveVersion="4.0.0" instanceLabel="GLOBAL_SCU_XMC1_0" appLabel="">
  <upwardMapList xsi:type="ResourceModel:RequiredApp" href="../../RTC/v4_1_10/RTC_0.app#//@requiredApps.1"/>
  <properties singleton="true" provideInit="true" sharable="true"/>
  <virtualSignals name="sr_irq0" URI="http://resources/4.1.6/app/GLOBAL_SCU_XMC1/0/vs_sr0_signal_in" hwSignal="signal_in" hwResource="//@hwResources.0"/>
  <virtualSignals name="sr_irq1" URI="http://resources/4.1.6/app/GLOBAL_SCU_XMC1/0/vs_sr1_signal_in" hwSignal="signal_in" hwResource="//@hwResources.1"/>
  <virtualSignals name="sr_irq2" URI="http://resources/4.1.6/app/GLOBAL_SCU_XMC1/0/vs_sr2_signal_in" hwSignal="signal_in" hwResource="//@hwResources.2"/>
  <requiredApps URI="http://resources/4.1.6/app/GLOBAL_SCU_XMC1/0/appres_cpu" requiredAppName="CPU_CTRL_XMC1" requiringMode="SHARABLE">
    <downwardMapList xsi:type="ResourceModel:App" href="../../CPU_CTRL_XMC1/v4_0_6/CPU_CTRL_XMC1_0.app#/"/>
  </requiredApps>
  <hwResources name="NVIC Node 0" URI="http://resources/4.1.6/app/GLOBAL_SCU_XMC1/0/hwres_sr0_scunode" resourceGroupUri="peripheral/cpu/0/nvic/interrupt/sv0" solverVariable="true" mResGrpUri="peripheral/cpu/0/nvic/interrupt/sv0">
    <downwardMapList xsi:type="ResourceModel:ResourceGroup" href="../../../HW_RESOURCES/CPU/CPU_0.dd#//@provided.6"/>
    <solverVarMap index="5">
      <value variableName="sv0" solverValue="0"/>
    </solverVarMap>
    <solverVarMap index="5">
      <value variableName="sv0" solverValue="0"/>
    </solverVarMap>
  </hwResources>
  <hwResources name="NVIC Node 1" URI="http://resources/4.1.6/app/GLOBAL_SCU_XMC1/0/hwres_sr1_scunode" resourceGroupUri="peripheral/cpu/0/nvic/interrupt/sv1" solverVariable="true" mResGrpUri="peripheral/cpu/0/nvic/interrupt/sv1">
    <downwardMapList xsi:type="ResourceModel:ResourceGroup" href="../../../HW_RESOURCES/CPU/CPU_0.dd#//@provided.10"/>
    <solverVarMap index="5">
      <value variableName="sv1" solverValue="1"/>
    </solverVarMap>
    <solverVarMap index="5">
      <value variableName="sv1" solverValue="1"/>
    </solverVarMap>
  </hwResources>
  <hwResources name="NVIC Node 2" URI="http://resources/4.1.6/app/GLOBAL_SCU_XMC1/0/hwres_sr2_scunode" resourceGroupUri="peripheral/cpu/0/nvic/interrupt/sv2" solverVariable="true" mResGrpUri="peripheral/cpu/0/nvic/interrupt/sv2">
    <downwardMapList xsi:type="ResourceModel:ResourceGroup" href="../../../HW_RESOURCES/CPU/CPU_0.dd#//@provided.12"/>
    <solverVarMap index="5">
      <value variableName="sv2" solverValue="2"/>
    </solverVarMap>
    <solverVarMap index="5">
      <value variableName="sv2" solverValue="2"/>
    </solverVarMap>
  </hwResources>
</ResourceModel:App>
