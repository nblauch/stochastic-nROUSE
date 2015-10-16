#-------------------------------------------#
# Examples of how to plot a RT distribution #
# Kevin Potter                              #
#-------------------------------------------#

# 1)
# Simulate RT data
N = 1000 # Sample size
ch = rbinom( N, 1, .8) # Generate accuracy independently using a bernoulli distribution
# 1 = correct, 0 = incorrect
# rbinom( Sample size, # of possible successes, Probability of a success )
rt = rgamma( N, shape = 2, scale = .3 ) # Generate response times from a gamma distribution

# 2)
# Plotting the joint density
prp = mean( ch ) # Determine the proportion of accurate responses
d1 = density( rt[ch==1] ) # Determine the empirical density for accurate RTs
d0 = density( rt[ch==0] ) # Determine the empirical density for inaccurate RTs

# For greater control, I prefer to generate an empty plot first
x11(); # Create a new plotting window
xl = c( 0, 2 ); yl = c( 0, max( c(d1$y,d0$y) ) ) # Define x and y-axis limits
plot( xl, 
      yl, 
      type = 'n', # Suppresses plotting
      xlab = 'RT (s)',
      ylab = 'Density',
      main = 'Joint density for RTs',
      bty = 'n' # Suppresses box around plot
)
lines( d1$x, d1$y*prp )
lines( d0$x, d0$y*(1-prp), lty = 2) # Use a dashed line
abline(h=0)

legend( xl[1], yl[2],
        c('Correct','Wrong'), # Legend labels
        lty = c(1,2), # Solid and dashed lines
        bty = 'n' # Suppresses box around the legend
)

# 3)
# Plotting empirical CDFs using quantiles
prp = mean( ch ) # Determine the proportion of accurate responses
prb = seq( .1, .9, .2) # Define the quantile proportions of interest
# Use R's 'aggregate' function to quickly calculate the 
# .1, .3, .5, .7, and .9 quantiles for both accurate and 
# and inaccurate choices
# The general structure of the aggregate command:
# aggregate( Dependent variable(s),
#            list( Covariates of interest ),
#            Function to calculate at each level of the covariates )
qnt = aggregate( rt, list( ch ), quantile, prob = prb )
colnames(qnt)[1] = 'Accuracy' # Relabel

x11(); # Create a new plotting window
xl = c( 0, 1.5 ); yl = c( 0, 1 ) # Define x and y-axis limits
plot( xl, 
      yl, 
      type = 'n', # Suppresses plotting
      xlab = 'RT (s)',
      ylab = 'Cumulative density',
      main = 'Joint CDF for RTs',
      xaxt='n', # Suppresses x-axis markers
      bty = 'n' # Suppresses box around plot
)
# Here, I create a custom x-axis
axis( 1, seq(0,1.5,.5), seq(0,1.5,.5),
      tick = T, lwd = 0 )
segments( seq(0,1.5,.5), 0, seq(0,1.5,.5), -.03 )
abline(h=0)

# Accurate responses
lines( qnt$x[qnt$Accuracy==1,], prb*prp )
points( qnt$x[qnt$Accuracy==1,], prb*prp, pch=19 )
# Inaccurate responses
lines( qnt$x[qnt$Accuracy==0,], prb*(1-prp), lty=2 )
points( qnt$x[qnt$Accuracy==0,], prb*(1-prp), pch=15 )

# Clean up the workspace
rm(rt,ch,d0,d1,N,prb,prp,qnt,xl,yl)

