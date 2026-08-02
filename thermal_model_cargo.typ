#let r2(val) = calc.round(val, digits: 2)

#let Solflux = 1361
#let LunIRflux = 1023
#let LunIRfluxNight = 20
#let Lunalbflux = 204.15
#let sideshort = 2.8 * 1.6
#let sidelong = 4.5 * 1.6
#let top = 2.8 * 4.5
#let bottom = 2.8 * 4.5
#let alphaStef = 0.09
#let epsilonntef = 0.81
#let alphaSkap = 0.09
#let epsilonnkap = 0.03
#let Qi = 1000
#let sigmaa = 5.67037 * calc.pow(10, -8)
#let minTempC = 15
#let epsilonnlouvClosed = 0.14
#let epsilonnlouvOpen = 0.74
#let alphalouvClosed = 0.14
#let alphalouvOpen = 0.14

= Cargo Hopper Thermal Profile

== Input Parameters Overview

#table(
  columns: (auto, auto),
  align: horizon,
  stroke: none,
  [*Parameter*], [*Value*],
  [Solar Flux (`Solflux`)], [#Solflux $W\/m^2$],
  [Lunar IR Flux (`LunIRflux`)], [#LunIRflux $W\/m^2$],
  [Lunar IR Flux Night (`LunIRfluxNight`)], [#LunIRfluxNight $W\/m^2$],
  [Lunar Albedo Flux (`Lunalbflux`)], [#Lunalbflux $W\/m^2$],
  [Side Short Area], [#sideshort $m^2$],
  [Side Long Area], [#sidelong $m^2$],
  [Top Area], [#top $m^2$],
  [Bottom Area], [#bottom $m^2$],
  [Alpha Stef (`alphaStef`)], [#alphaStef],
  [Epsilon Stef (`epsilonntef`)], [#epsilonntef],
  [Alpha Kap (`alphaSkap`)], [#alphaSkap],
  [Epsilon Kap (`epsilonnkap`)], [#epsilonnkap],
  [Internal Heat (`Qi`)], [#Qi $W$],
  [Stefan-Boltzmann Constant (`sigmaa`)], [#sigmaa $W\/(m^2 K^4)$],
  [Minimum Temp (`minTempC`)], [#minTempC $°C$],
  [Epsilon Louvers Closed (`epsilonnlouvClosed`)], [#epsilonnlouvClosed],
  [Epsilon Louvers Open (`epsilonnlouvOpen`)], [#epsilonnlouvOpen],
  [Alpha Louvers Closed (`alphalouvClosed`)], [#alphalouvClosed],
  [Alpha Louvers Open (`alphalouvOpen`)], [#alphalouvOpen],
)

=== Sizing of Thermal Louvers

#let LouversWidth = 532.13 / 1000
#let LouversHeight = 397.002 / 1000
#let LouversThick = 62.99 / 1000
#let LouversAreaTotal = LouversWidth * LouversHeight
#let LouversAreaRad = 0.16
#let LouversAreaEff = LouversAreaRad / LouversAreaTotal
#let TefAreaEff = 1 - LouversAreaEff

The 20 blade passive thermal Louvers by Sierra Space have a width of #r2(LouversWidth) $m$, 
height of #r2(LouversHeight) $m$ and a thickness of #r2(LouversThick) $m$.
This results in a total area of #r2(LouversAreaTotal) $m^2$ per thermal Louvers.
The radiative area is stated as #r2(LouversAreaRad) $m^2$ which results in an effective area portion of #r2(LouversAreaEff).
The rest (#r2(TefAreaEff)) is assumed to be covered in silvered Teflon.

Heat produced by internal systems $Q_i = #Qi W$

Longest side assumed for worst case scenario. Only one Side illuminated by the Sun at once, all sides other than top are illuminated by Moon IR and albedo.

== Scenario A: Day

Louvers are open.

#let incSun = 45deg
#let incMoonIR = 45deg
#let incMoonAlb = 45deg

Incidence angles: \
Sun: $gamma = #incSun.deg()°$, \
Moon IR to sidepannel: $delta = #incMoonIR.deg()°$, \
Moon Albedo to sidepannel: $theta = #incMoonAlb.deg()°$.

*Absorption*

#let Q_SUNTop = Solflux * calc.cos(incSun) * (alphaStef * top * TefAreaEff + alphalouvOpen * top * LouversAreaEff)

$Q_(S U N)_(T o p) = cos(gamma) q_S (alpha_S_(t e f)  A_(t o p) times "TefAreaEff" + alpha_S_("louvOpen")  A_(t o p) times "LouversAreaEff")  = #r2(Q_SUNTop) W$

#let Q_SUNSide = alphaSkap * Solflux * sidelong * calc.sin(incSun)

$Q_(S U N)_(S i d e l o n g) = alpha_S_(k a p) q_S A_(S i d e l o n g) sin(gamma) = #r2(Q_SUNSide) W$

#let Q_MoonIRSidelong = 2 * alphaSkap * LunIRflux * sidelong * calc.cos(incMoonIR)

$Q_(M o o n I R)_(S i d e l o n g) = 2alpha_S_(k a p) q_("mIR") A_(S i d e l o n g) cos(delta) = #r2(Q_MoonIRSidelong) W$

#let Q_MoonIRSideshort = 2 * alphaSkap * LunIRflux * sideshort * calc.cos(incMoonIR)

$Q_(M o o n I R)_(S i d e s h o r t) = 2alpha_S_(k a p) q_("mIR") A_(S i d e s h o r t) cos(delta) = #r2(Q_MoonIRSideshort) W$

#let Q_MoonIRbottom = alphaSkap * LunIRflux * bottom

$Q_(M o o n I R)_(b o t t o m) = alpha_S_(k a p) q_("mIR") A_(S i d e s h o r t) = #r2(Q_MoonIRbottom) W$

#let Q_MoonalbSidelong = alphaSkap * Lunalbflux * sidelong * calc.cos(incMoonAlb)

$Q_(M o o n A l b)_(S i d e s l o n g) = alpha_S_(k a p) q_m A_(S i d e s h o r t) cos(theta) = #r2(Q_MoonalbSidelong) W$

#let Q_Moonalbbottom = alphaSkap * Lunalbflux * bottom * calc.cos(incMoonAlb)

$Q_(M o o n A l b)_("bottom") = 2alpha_S_(k a p) q_m A_("bottom") cos(theta) = #r2(Q_Moonalbbottom) W$

*Emission*

$Q_(r a d)_(T o p) = epsilon_n_(t e f) sigma T^4 A_(t o p) times "TefAreaEff" + epsilon_n_("louvOpen") sigma T^4 A_(t o p) times "LouversAreaEff"$

$Q_(r a d)_(S i d e l o n g) = 2 epsilon_n_(k a p) sigma T^4 A_(S i d e l o n g)$

$Q_(r a d)_(S i d e s h o r t) = 2 epsilon_n_(k a p) sigma T^4 A_(S i d e s h o r t)$

$Q_(r a d)_(b o t t o m) = epsilon_n_(k a p) sigma T^4 A_(b o t t o m)$

*Temperature*
#let absorbed = Q_SUNTop + Q_SUNSide + Q_MoonIRSidelong + Q_MoonIRSideshort + Q_MoonIRbottom + Q_MoonalbSidelong + Q_Moonalbbottom
#let emitted = sigmaa * (epsilonntef * top * TefAreaEff + epsilonnlouvOpen * top * LouversAreaEff + 2 * epsilonnkap * sidelong + 2 * epsilonnkap * sideshort + epsilonnkap * bottom)
#let temp = calc.root(((absorbed + Qi) / emitted), 4)
#let tempC = temp - 273.15

$Q_("absorbed") = 
    Q_(S U N)_(T o p) + 
    Q_(S U N)_(S i d e l o n g) + 
    Q_(M o o n I R)_(S i d e l o n g) + 
    Q_(M o o n I R)_(S i d e s h o r t) + 
    Q_(M o o n I R)_(b o t t o m) + 
    Q_(M o o n A l b)_(S i d e s l o n g) +
    Q_(M o o n A l b)_("bottom")$

$Q_("emitted") = Q_(r a d)_(T o p) + Q_(r a d)_(S i d e l o n g) + Q_(r a d)_(S i d e s h o r t) + Q_(r a d)_(b o t t o m)$

$T = root(4, (Q_("absorbed") + Q_i) / (Q_("emitted") / T^4)) = #r2(temp) K = #r2(tempC) °C$

Heating required to stay at #minTempC°C: 
#if tempC < minTempC {
    let emittedAt15 = emitted * calc.pow((minTempC + 273.15), 4)
    let Qheater = emittedAt15 - absorbed - Qi
    [
        \ $Q_("absorbed") + Q_i - Q_("emitted") + Q_("heater") = 0 => 
        Q_("emitted") - Q_("absorbed") - Q_i = Q_("heater") = #r2(Qheater) W$
    ]
    
} else {
    [*None*]
}

== Scenario B: Noon

Louvers are open.

#let incSun = 0deg
#let incMoonIR = 45deg
#let incMoonAlb = 90deg

Incidence angles: \
Sun: $gamma = #incSun.deg()°$, \
Moon IR to sidepannel: $delta = #incMoonIR.deg()°$, \
Moon Albedo to sidepannel: $theta = #incMoonAlb.deg()°$.

*Absorption*

#let Q_SUNTop = Solflux * calc.cos(incSun) * (alphaStef * top * TefAreaEff + alphalouvOpen * top * LouversAreaEff)

$Q_(S U N)_(T o p) = cos(gamma) q_S (alpha_S_(t e f)  A_(t o p) times "TefAreaEff" + alpha_S_("louvOpen")  A_(t o p) times "LouversAreaEff")  = #r2(Q_SUNTop) W$

#let Q_SUNSide = alphaSkap * Solflux * sidelong * calc.sin(incSun)

$Q_(S U N)_(S i d e l o n g) = alpha_S_(k a p) q_S A_(S i d e l o n g) sin(gamma) = #r2(Q_SUNSide) W$

#let Q_MoonIRSidelong = 2 * alphaSkap * LunIRflux * sidelong * calc.cos(incMoonIR)

$Q_(M o o n I R)_(S i d e l o n g) = 2alpha_S_(k a p) q_("mIR") A_(S i d e l o n g) cos(delta) = #r2(Q_MoonIRSidelong) W$

#let Q_MoonIRSideshort = 2 * alphaSkap * LunIRflux * sideshort * calc.cos(incMoonIR)

$Q_(M o o n I R)_(S i d e s h o r t) = 2alpha_S_(k a p) q_("mIR") A_(S i d e s h o r t) cos(delta) = #r2(Q_MoonIRSideshort) W$

#let Q_MoonIRbottom = alphaSkap * LunIRflux * bottom

$Q_(M o o n I R)_(b o t t o m) = alpha_S_(k a p) q_("mIR") A_(S i d e s h o r t) = #r2(Q_MoonIRbottom) W$

#let Q_MoonalbSidelong = alphaSkap * Lunalbflux * sidelong * calc.cos(incMoonAlb)

$Q_(M o o n A l b)_(S i d e s l o n g) = alpha_S_(k a p) q_m A_(S i d e s h o r t) cos(theta) = #r2(Q_MoonalbSidelong) W$

#let Q_Moonalbbottom = alphaSkap * Lunalbflux * bottom * calc.cos(incMoonAlb)

$Q_(M o o n A l b)_("bottom") = 2alpha_S_(k a p) q_m A_("bottom") cos(theta) = #r2(Q_Moonalbbottom) W$

*Emission*

$Q_(r a d)_(T o p) = epsilon_n_(t e f) sigma T^4 A_(t o p) times "TefAreaEff" + epsilon_n_("louvOpen") sigma T^4 A_(t o p) times "LouversAreaEff"$

$Q_(r a d)_(S i d e l o n g) = 2 epsilon_n_(k a p) sigma T^4 A_(S i d e l o n g)$

$Q_(r a d)_(S i d e s h o r t) = 2 epsilon_n_(k a p) sigma T^4 A_(S i d e s h o r t)$

$Q_(r a d)_(b o t t o m) = epsilon_n_(k a p) sigma T^4 A_(b o t t o m)$

*Temperature*
#let absorbed = Q_SUNTop + Q_SUNSide + Q_MoonIRSidelong + Q_MoonIRSideshort + Q_MoonIRbottom + Q_MoonalbSidelong + Q_Moonalbbottom
#let emitted = sigmaa * (epsilonntef * top * TefAreaEff + epsilonnlouvOpen * top * LouversAreaEff + 2 * epsilonnkap * sidelong + 2 * epsilonnkap * sideshort + epsilonnkap * bottom)
#let temp = calc.root(((absorbed + Qi) / emitted), 4)
#let tempC = temp - 273.15

$Q_("absorbed") = 
    Q_(S U N)_(T o p) + 
    Q_(S U N)_(S i d e l o n g) + 
    Q_(M o o n I R)_(S i d e l o n g) + 
    Q_(M o o n I R)_(S i d e s h o r t) + 
    Q_(M o o n I R)_(b o t t o m) + 
    Q_(M o o n A l b)_(S i d e s l o n g) +
    Q_(M o o n A l b)_("bottom")$

$Q_("emitted") = Q_(r a d)_(T o p) + Q_(r a d)_(S i d e l o n g) + Q_(r a d)_(S i d e s h o r t) + Q_(r a d)_(b o t t o m)$

$T = root(4, (Q_("absorbed") + Q_i) / (Q_("emitted") / T^4)) = #r2(temp) K = #r2(tempC) °C$

Heating required to stay at #minTempC°C: 
#if tempC < minTempC {
    let emittedAt15 = emitted * calc.pow((minTempC + 273.15), 4)
    let Qheater = emittedAt15 - absorbed - Qi
    [
        \ $Q_("absorbed") + Q_i - Q_("emitted") + Q_("heater") = 0 => 
        Q_("emitted") - Q_("absorbed") - Q_i = Q_("heater") = #r2(Qheater) W$
    ]
    
} else {
    [*None*]
}

== Scenario C: Night

Louvers are closed.

#let incMoonIR = 45deg

Incidence angles: \
Moon IR to sidepannel: $delta = #incMoonIR.deg()°$, \

*Absorption*

#let Q_MoonIRSidelong = 2 * alphaSkap * LunIRfluxNight * sidelong * calc.cos(incMoonIR)

$Q_(M o o n I R)_(S i d e l o n g) = 2alpha_S_(k a p) q_("mIR") A_(S i d e l o n g) cos(delta) = #r2(Q_MoonIRSidelong) W$

#let Q_MoonIRSideshort = 2 * alphaSkap * LunIRfluxNight * sideshort * calc.cos(incMoonIR)

$Q_(M o o n I R)_(S i d e s h o r t) = 2alpha_S_(k a p) q_("mIR") A_(S i d e s h o r t) cos(delta) = #r2(Q_MoonIRSideshort) W$

#let Q_MoonIRbottom = alphaSkap * LunIRfluxNight * bottom

$Q_(M o o n I R)_(b o t t o m) = alpha_S_(k a p) q_("mIR") A_(S i d e s h o r t) = #r2(Q_MoonIRbottom) W$

*Emission*

$Q_(r a d)_(T o p) = epsilon_n_(t e f) sigma T^4 A_(t o p) times "TefAreaEff" + epsilon_n_("louvClosed") sigma T^4 A_(t o p) times "LouversAreaEff"$

$Q_(r a d)_(S i d e l o n g) = 2 epsilon_n_(k a p) sigma T^4 A_(S i d e l o n g)$

$Q_(r a d)_(S i d e s h o r t) = 2 epsilon_n_(k a p) sigma T^4 A_(S i d e s h o r t)$

$Q_(r a d)_(b o t t o m) = epsilon_n_(k a p) sigma T^4 A_(b o t t o m)$

*Temperature*
#let absorbed = Q_MoonIRSidelong + Q_MoonIRSideshort + Q_MoonIRbottom
#let emitted = sigmaa * (epsilonntef * top * TefAreaEff + epsilonnlouvClosed * top * LouversAreaEff + 2 * epsilonnkap * sidelong + 2 * epsilonnkap * sideshort + epsilonnkap * bottom)
#let temp = calc.root(((absorbed + Qi) / emitted), 4)
#let tempC = temp - 273.15

$Q_("absorbed") = 
    Q_(M o o n I R)_(S i d e l o n g) + 
    Q_(M o o n I R)_(S i d e s h o r t) + 
    Q_(M o o n I R)_(b o t t o m)$

$Q_("emitted") = Q_(r a d)_(T o p) + Q_(r a d)_(S i d e l o n g) + Q_(r a d)_(S i d e s h o r t) + Q_(r a d)_(b o t t o m)$

$T = root(4, (Q_("absorbed") + Q_i) / (Q_("emitted") / T^4)) = #r2(temp) K = #r2(tempC) °C$

Heating required to stay at #minTempC°C: 
#if tempC < minTempC {
    let emittedAt15 = emitted * calc.pow((minTempC + 273.15), 4)
    let Qheater = emittedAt15 - absorbed - Qi
    [
        \ $Q_("absorbed") + Q_i - Q_("emitted") + Q_("heater") = 0 => 
        Q_("emitted") - Q_("absorbed") - Q_i = Q_("heater") = #r2(Qheater) W$
    ]
    
} else {
    [*None*]
}

== Scenario D: PSR

Louvers are closed.

*Absorption*

None

*Emission*

$Q_(r a d)_(T o p) = epsilon_n_(t e f) sigma T^4 A_(t o p) times "TefAreaEff" + epsilon_n_("louvClosed") sigma T^4 A_(t o p) times "LouversAreaEff"$

$Q_(r a d)_(S i d e l o n g) = 2 epsilon_n_(k a p) sigma T^4 A_(S i d e l o n g)$

$Q_(r a d)_(S i d e s h o r t) = 2 epsilon_n_(k a p) sigma T^4 A_(S i d e s h o r t)$

$Q_(r a d)_(b o t t o m) = epsilon_n_(k a p) sigma T^4 A_(b o t t o m)$

*Temperature*
#let absorbed = 0
#let emitted = sigmaa * (epsilonntef * top * TefAreaEff + epsilonnlouvClosed * top * LouversAreaEff + 2 * epsilonnkap * sidelong + 2 * epsilonnkap * sideshort + epsilonnkap * bottom)
#let temp = calc.root(((absorbed + Qi) / emitted), 4)
#let tempC = temp - 273.15

$Q_("absorbed") = 
    Q_(M o o n I R)_(S i d e l o n g) + 
    Q_(M o o n I R)_(S i d e s h o r t) + 
    Q_(M o o n I R)_(b o t t o m)$

$Q_("emitted") = Q_(r a d)_(T o p) + Q_(r a d)_(S i d e l o n g) + Q_(r a d)_(S i d e s h o r t) + Q_(r a d)_(b o t t o m)$

$T = root(4, (Q_("absorbed") + Q_i) / (Q_("emitted") / T^4)) = #r2(temp) K = #r2(tempC) °C$

Heating required to stay at #minTempC°C: 
#if tempC < minTempC {
    let emittedAt15 = emitted * calc.pow((minTempC + 273.15), 4)
    let Qheater = emittedAt15 - absorbed - Qi
    [
        \ $Q_("absorbed") + Q_i - Q_("emitted") + Q_("heater") = 0 => 
        Q_("emitted") - Q_("absorbed") - Q_i = Q_("heater") = #r2(Qheater) W$
    ]
    
} else {
    [*None*]
}