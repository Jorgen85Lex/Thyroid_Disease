server <- function(input, output, session) {
  
  # Initialize reactive value to track button state
  compare_clicked <- reactiveVal(FALSE)
  
  # When the compare button is clicked, update the reactive value to TRUE
  observeEvent(input$compare_button, {
    compare_clicked(TRUE)
  })
  
  # Normal TSH range
  normal_ranges <- list(
    "Babies < 1" = c(min = 0.7, max = 15.2),
    "Children 1-6" = c(min = 0.7, max = 5.97),
    "Children 7-11" = c(min = 0.6, max = 4.84),
    "Ages 12-20" = c(min = 0.51, max = 4.3),
    "Adults 21-99" = c(min = 0.27, max = 4.2)
  )
  
  # Filtered data based on user input
  filtered_data <- reactive({
    data <- thyroid_df_shiny[!is.na(thyroid_df_shiny$TSH) & !is.na(thyroid_df_shiny$age), ]
    
    # Age groups for TSH levels
    data$age_group <- cut(data$age,
                          breaks = c(-Inf, 1, 6, 11, 20, 99),
                          labels = c("Babies < 1", "Children 1-6", "Children 7-11", "Ages 12-20", "Adults 21-99"),
                          right = TRUE)
    
    data <- data[abs(data$TSH - input$tsh_value) <= 1, ]
    
    if (input$sex != "All") {
      data <- data[data$sex == input$sex, ]
    }
    
    if (input$age_range != "All") {
      data <- data[data$age_group == input$age_range, ]
    }
    
    return(data)
  })
  
  # TSH histogram + user compare
  output$TSHhistogram <- renderPlot({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return(NULL)
    }
    
    # Inputted data by user for comparison
    user_data <- data.frame(
      age = input$user_age,
      TSH = input$user_tsh,
      sex = "User",
      age_group = cut(input$user_age, breaks = c(-Inf, 1, 6, 11, 20, 99), 
                      labels = c("Babies < 1", "Children 1-6", "Children 7-11", "Ages 12-20", "Adults 21-99")),
      stringsAsFactors = FALSE
    )
    
    # Plotting the histogram
    plot <- ggplot(data, aes(x = TSH, fill = sex)) +
      geom_histogram(binwidth = 1, color = "black", alpha = 0.7, position = "dodge") +
      facet_wrap(~ age_group, nrow = 1) +
      labs(title = paste("Histogram of TSH Levels Around", input$tsh_value, "Across Different Age Ranges by Sex"),
           x = "TSH Level",
           y = "Frequency") +
      scale_fill_manual(values = c("F" = "pink", "M" = "skyblue")) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 20),
        axis.title.y = element_text(size = 14),
        axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        plot.margin = margin(t = 30, b = 40),
        strip.text = element_text(size = 12, margin = margin(t = 10, b = 10)),
        panel.spacing = unit(2, "lines")
      )
    
    # Add the red dashed line only if the button has been clicked (compare_clicked is TRUE)
    if (compare_clicked()) {
      plot <- plot + geom_vline(data = user_data, aes(xintercept = TSH), color = "red", size = 1.5, linetype = "dashed")
    }
    
    return(plot)
  })
  
  output$no_labs_available_message <- renderText({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return("No results matching that input.")
    } else {
      return(NULL)
    }
  })
  
  # Comparison message when the button is clicked
  observeEvent(input$compare_button, {
    data <- filtered_data()
    
    normal_range <- normal_ranges[[input$age_range]]
    normal_min <- normal_range["min"]
    normal_max <- normal_range["max"]
    
    # Normal range for TSH values
    normal_status <- "within range"
    if (input$user_tsh < normal_min) {
      normal_status <- "lower than expected"
    } else if (input$user_tsh > normal_max) {
      normal_status <- "higher than expected"
    }
    
    user_comparison_message <- paste("Your TSH value is ", input$user_tsh, ".\n",
                                     "This is ", normal_status, " for your age group (", input$age_range, ").\n")
    
    output$comparison_message <- renderText({
      user_comparison_message
    })
  })
}






                                                                                                                             

                                                                                                                       
                                                                                                                       

                                       




