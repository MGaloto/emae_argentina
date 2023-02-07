FROM rocker/shiny:4.1.3

# Instalar paquete remotes para controlar las versiones de otros paquetes
RUN R -e 'install.packages("remotes", repos="http://cran.rstudio.com")'

# install needed R packages
RUN R -e "install.packages('highcharter', dependencies = TRUE)"
RUN R -e "install.packages('XML', dependencies = TRUE)"
RUN R -e "install.packages('rlist', dependencies = TRUE)"
RUN R -e "install.packages('rlang', dependencies = TRUE)"
RUN R -e 'remotes::install_version(package = "tidyverse", version = "1.3.1", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "lubridate", version = "1.7.10", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "rsconnect", version = "0.8.25", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "shinyFeedback", version = "0.4.0", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "glue", version = "1.4.2", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "shinydashboard", version = "0.7.2", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "writexl", version = "1.4.0", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "httr", version = "1.4.2", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "cpp11", version = "0.4.1", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "dplyr", version = "1.0.7", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "tidyr", version = "1.2.0", dependencies = TRUE)'
RUN R -e 'remotes::install_version(package = "readxl", version = "1.4.0", dependencies = TRUE)'


WORKDIR /home/shinyemae
COPY app.R app.R 
COPY download_emae.R download_emae.R 
COPY deploy.R deploy.R
COPY www/styles.css www/styles.css
CMD Rscript deploy.R

