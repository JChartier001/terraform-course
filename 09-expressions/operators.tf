locals {
  math       = 2 * 2         # math operatorsL * + - / % -<number>
  equality   = 2 == 2        # equality operators: == != 
  comparison = 2 < 3         # comparison operators: < > <= >=
  logic      = true && false # logic operators: && || !

}

output "operators" {
  value = {
    math       = local.math
    equality   = local.equality
    comparison = local.comparison
    logic      = local.logic
  }
}