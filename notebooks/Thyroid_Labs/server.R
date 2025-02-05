server <- function(input, output, session) {
  
  reactive_age_range <- reactive({
    age <- input$user_age
    
    if (age < 1) {
      return("Babies < 1")
    } else if (age >= 1 && age <= 6) {
      return("Children 1-6")
    } else if (age >= 7 && age <= 11) {
      return("Children 7-11")
    } else if (age >= 12 && age <= 20) {
      return("Ages 12-20")
    } else if (age >= 21 && age <= 99) {
      return("Adults 21-99")
    } else {
      return("Adults 21-99")
    }
  })
  
  observe({
    selected_range <- reactive_age_range()
    
    updateSelectInput(session, "comparison_age_range", selected = selected_range)
  })
  
  
  compare_clicked <- reactiveVal(FALSE)
  
  observeEvent(input$compare_button, {
    req(input$user_age, input$user_tsh)
    compare_clicked(TRUE)
    print(paste("Button clicked. TSH value: ", input$user_tsh)) 
  })
  
  # Normal TSH range
  normal_ranges <- list(
    "Babies < 1" = c(min = 0.7, max = 15.2),
    "Children 1-6" = c(min = 0.7, max = 5.97),
    "Children 7-11" = c(min = 0.6, max = 4.84),
    "Ages 12-20" = c(min = 0.51, max = 4.3),
    "Adults 21-99" = c(min = 0.27, max = 4.2)
  )
  
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
    
    return(data)
  })
  
  # TSH histogram 
  output$TSHhistogram <- renderPlot({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return(NULL)
    }
    

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
    
    if (compare_clicked()) {
      plot <- plot + 
        geom_vline(
          data = data[data$age_group == reactive_age_range(), ],
          aes(xintercept = input$user_tsh),
          color = "red", 
          linetype = "dashed", 
          size = 1
        )
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
  
  observeEvent(input$compare_button, {
    req(input$user_age, input$user_tsh) 
    
    normal_range <- normal_ranges[[input$comparison_age_range]]
    normal_min <- normal_range["min"]
    normal_max <- normal_range["max"]
    
    normal_status <- "within range"
    if (input$user_tsh < normal_min) {
      normal_status <- "lower than expected"
    } else if (input$user_tsh > normal_max) {
      normal_status <- "higher than expected"
    }
    
    user_comparison_message <- paste("Your TSH value is ", input$user_tsh, ".\n",
                                     "This is ", normal_status, " for your age group (", input$comparison_age_range, ").\n")
    
    output$comparison_message <- renderText({
      user_comparison_message
    })
  })
}




                                                                                                                             

                                                                                                                       
                                                                                                                       

                                       




