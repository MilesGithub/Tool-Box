# Example function to create data frames with counter
create_row <- function(x, counter) {
  data.frame(ID = counter, Value = x)
}

# Sample list of values
values <- list(10, 20, 30, 40)

# Use lapply to loop with a counter and rbind the results
result <- do.call(rbind, lapply(seq_along(values), function(i) {
  create_row(values[[i]], i)
}))

# View result
print(result)
