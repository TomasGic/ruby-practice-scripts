employee = {
  name: "Tomas", age: 34, current_city: "Amsterdam"
}

puts employee[:current_city]


employees = {
  101 => {name: "Tomas", age: 34, current_city: "Amsterdam"},
  102 => {name: "Martin", age: 34, current_city: "Bratislava"},
  103 => {name: "Lucas", age: 36, current_city: "Zilina"}
}

puts employees[101][:age]