= Estimation of Boil off rate of LOX and LH2

#let rounding = 3
#let hopper_names = (cargo: "Cargo Hopper", exploration: "Exploration Hopper")

== Constant Parameters
#let temp_max = 393.15
#let insulator_thi = 0.0077
#let lambdaa = 0.000019
#let temp_LOX = 90.19
#let temp_LH2 = 20.28
#let latent_OX = 213
#let latent_H2 = 445.5

#table(
  columns: (auto, auto, auto),
  table.header([*Parameter*], [*Value*], [*Symbol*]),
  [Maximum Temperature \ outside of tank], [$#temp_max K$], [$T_("max")$],
  [Thickness of Insulator], [$#insulator_thi m$], [$x$],
  [Thermal conductivity of Insulator], [$lambdaa W/(m K)$], [$lambda$],
  [Temperature of LOX inside of Tank], [$#temp_LOX K$], [$T_("LOX")$],
  [Temperature of LH2 inside of Tank], [$#temp_LH2 K$], [$T_("LH2")$],
  [Latent heat of vaporization for Oxygen], [$#latent_OX J/g$], [$L_("OX")$],
  [Latent heat of vaporization for Hydrogen], [$#latent_H2 J/g$], [$L_("H2")$],
)

#let tank_shapes = (cargo: "sphere", exploration: "capsule")
#let radii_LOX = (cargo: 0.69 / 2, exploration: 0.6 / 2)
#let radii_LH2 = (cargo: 0.99 / 2, exploration: 0.85 / 2)
#let num_LOX = (cargo: 2, exploration: 2)
#let num_LH2 = (cargo: 2, exploration: 2)
#let capsule_heights_LOX = (cargo: none, exploration: 1.2)
#let capsule_heights_LH2 = (cargo: none, exploration: 1.5)


#for hopper in hopper_names.keys() {
  [
    == Calculations for #hopper_names.at(hopper)
    === Parameters
  ]
  

  let tank_shape = tank_shapes.at(hopper)
  let radius_LOX = radii_LOX.at(hopper)
  let radius_LH2 = radii_LH2.at(hopper)
  let num_LOX = num_LOX.at(hopper)
  let num_LH2 = num_LH2.at(hopper)
  let capsule_height_LOX = capsule_heights_LOX.at(hopper)
  let capsule_height_LH2 = capsule_heights_LH2.at(hopper)

  if tank_shape == "sphere" {
    table(
      columns: (auto, auto, auto),
      table.header([*Parameter*], [*Value*], [*Symbol*]),
      [Tank shape], [#tank_shape], [],
      [Radius of LOX tanks], [$#radius_LOX m$], [$r_("LOX")$],
      [Radius of LH2 tanks], [$#radius_LH2 m$], [$r_("LH2")$],
      [Number of LOX tanks], [#num_LOX], [$N_("LOX")$],
      [Number of LH2 tanks], [#num_LH2], [$N_("LH2")$],
    )
    [
      === Calculations
      Tank shape: #tank_shape \
      
      Tank outer Area: \
      #let Alox = 4 * calc.pi * radius_LOX * radius_LOX
      #let Alox_round = calc.round(Alox, digits: rounding)
      $A_("LOX") = 4 pi r_("LOX")^2 = #Alox_round m^2$ \
      #let Alh2 = 4 * calc.pi * radius_LH2 * radius_LH2
      #let Alh2_round = calc.round(Alh2, digits: rounding)
      $A_("LH2") = 4 pi r_("LH2")^2 = #Alh2_round m^2$

      Heat Transfer: \
      #let Qlox = lambdaa * Alox * ((temp_max - temp_LOX) / insulator_thi)
      #let Qlox_round = calc.round(Qlox, digits: rounding)
      $Q_("LOX") = lambda A_("LOX") (T_("max") - T_("LOX"))/x = #Qlox_round W$ \
      #let Qlh2 = lambdaa * Alh2 * ((temp_max - temp_LH2) / insulator_thi)
      #let Qlh2_round = calc.round(Qlh2, digits: rounding)
      $Q_("LH2") = lambda A_("LH2") (T_("max") - T_("LH2"))/x = #Qlh2_round W$

      Boil off rate: \
      #let mlox = num_LOX * (Qlox / latent_OX)
      #let mlox_round = calc.round(mlox, digits: rounding + 4)
      #let mlox_hour = calc.round(mlox * 3600, digits: rounding)
      $dot(m)_("LOX") = N_("LOX") Q_("LOX")/L_("OX") = #mlox_round g/s = #mlox_hour g/("hour")$ \
      #let mlh2 = num_LH2 * (Qlh2 / latent_H2)
      #let mlh2_round = calc.round(mlh2, digits: rounding + 4)
      #let mlh2_hour = calc.round(mlh2 * 3600, digits: rounding)
      $dot(m)_("LH2") = N_("LH2") Q_("LH2")/L_("H2") = #mlh2_round g/s = #mlh2_hour g/("hour")$

      #pagebreak()
    ]
  } 
  else if tank_shape == "capsule" {
    table(
      columns: (auto, auto, auto),
      table.header([*Parameter*], [*Value*], [*Symbol*]),
      [Tank shape], [#tank_shape], [],
      [Radius of LOX tanks], [$#radius_LOX m$], [$r_("LOX")$],
      [Radius of LH2 tanks], [$#radius_LH2 m$], [$r_("LH2")$],
      [Number of LOX tanks], [#num_LOX], [$N_("LOX")$],
      [Number of LH2 tanks], [#num_LH2], [$N_("LH2")$],
      [Height of LOX tanks], [#capsule_height_LOX m], [$h_("LOX")$],
      [Height of LH2 tanks], [#capsule_height_LH2 m], [$h_("LH2")$]
    )
    [
      === Calculations
      Tank shape: #tank_shape \
      
      Tank outer Area: \
      #let Alox = 2 * calc.pi * capsule_height_LOX * radius_LOX + 4 * calc.pi * radius_LOX * radius_LOX
      #let Alox_round = calc.round(Alox, digits: rounding)
      $A_("LOX") = 2 pi r_("LOX") h_("LOX") + 4 pi r_("LOX")^2 = #Alox_round m^2$ \
      #let Alh2 = 2 * calc.pi * capsule_height_LH2 * radius_LH2 + 4 * calc.pi * radius_LH2 * radius_LH2
      #let Alh2_round = calc.round(Alh2, digits: rounding)
      $A_("LH2") = 2 pi r_("LH2") h_("LH2") + 4 pi r_("LH2")^2 = #Alh2_round m^2$

      Heat Transfer: \
      #let Qlox = lambdaa * Alox * ((temp_max - temp_LOX) / insulator_thi)
      #let Qlox_round = calc.round(Qlox, digits: rounding)
      $Q_("LOX") = lambda A_("LOX") (T_("max") - T_("LOX"))/x = #Qlox_round W$ \
      #let Qlh2 = lambdaa * Alh2 * ((temp_max - temp_LH2) / insulator_thi)
      #let Qlh2_round = calc.round(Qlh2, digits: rounding)
      $Q_("LH2") = lambda A_("LH2") (T_("max") - T_("LH2"))/x = #Qlh2_round W$

      Boil off rate: \
      #let mlox = num_LOX * (Qlox / latent_OX)
      #let mlox_round = calc.round(mlox, digits: rounding + 4)
      #let mlox_hour = calc.round(mlox * 3600, digits: rounding)
      $dot(m)_("LOX") = N_("LOX") Q_("LOX")/L_("OX") = #mlox_round g/s = #mlox_hour g/("hour")$ \
      #let mlh2 = num_LH2 * (Qlh2 / latent_H2)
      #let mlh2_round = calc.round(mlh2, digits: rounding + 4)
      #let mlh2_hour = calc.round(mlh2 * 3600, digits: rounding)
      $dot(m)_("LH2") = N_("LH2") Q_("LH2")/L_("H2") = #mlh2_round g/s = #mlh2_hour g/("hour")$

      #pagebreak()
    ]
  }
}

