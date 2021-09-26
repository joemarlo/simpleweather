test_date <- as.Date("2021-09-24")
dates <- seq(test_date - 10, test_date + 5, by = 'day')
lat <- 40.7812
long <- -73.9665
weather <- get_weather(dates, lat, long)

test_that("get_weather returns a dataframe with the correct length", {
  expect_true(inherits(weather, 'data.frame'))
  expect_equal(nrow(weather), length(dates))
  expect_equal(colnames(weather), c("date", "temperature", "precipitation", "wind", "is_forecast", "source"))
})


