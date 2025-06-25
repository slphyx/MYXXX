# wrie SIR model using deSolve package
library(deSolve)
# SIR model function
sir_model <- function(t, state, parameters) {
  with(as.list(c(state, parameters)), {
    # Calculate the derivatives
    dS <- -beta * S * I / N
    dI <- beta * S * I / N - gamma * I
    dR <- gamma * I
    
    # Return the derivatives
    return(list(c(dS, dI, dR)))
  })
}
# Initial state
initial_state <- c(S = 999, I = 1, R = 0)
# Parameters
parameters <- c(beta = 0.3, gamma = 0.1)
# Time sequence
times <- seq(0, 160, by = 1)
# Solve the SIR model
sir_out <- ode(y = initial_state, times = times, func = sir_model, parms = parameters)
# Convert output to data frame
sir_df <- as.data.frame(sir_out)
# Rename columns
colnames(sir_df) <- c("time", "S", "I", "R")
# Plot the results
library(ggplot2)
ggplot(sir_df, aes(x = time)) +
  geom_line(aes(y = S, color = "Susceptible")) +
  geom_line(aes(y = I, color = "Infected")) +
  geom_line(aes(y = R, color = "Recovered")) +
  labs(title = "SIR Model", x = "Time", y = "Population") +
  scale_color_manual(values = c("blue", "red", "green")) +
  theme_minimal()
