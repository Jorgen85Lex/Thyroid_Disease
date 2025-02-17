server <- function(input, output, session) {
  #TSH age ranges for user input
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
  })
  
  # Normal TSH range
  normal_ranges <- list(
    "Babies < 1" = c(min = 0.7, max =8.35),
    "Children 1-6" = c(min = 0.7, max = 5.97),
    "Children 7-11" = c(min = 0.6, max = 4.84),
    "Ages 12-20" = c(min = 0.51, max = 4.3),
    "Adults 21-99" = c(min = 0.27, max = 4.2)
  )
  
  
  filtered_data <- reactive({
    data <- thyroid_df_shiny[!is.na(thyroid_df_shiny$TSH) & !is.na(thyroid_df_shiny$age), ]
    
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
      geom_histogram(aes(y= ..density..), binwidth = 1, color = "black", alpha = 0.7, position = "dodge") +
      facet_wrap(~sex + age_group, nrow = 2) +
      labs(title = paste("Histogram of TSH Levels Around", input$tsh_value, "Across Different Age Ranges by Sex"),
           x = "TSH Level",
           y = "Proportion") +
      scale_fill_manual(values = c("F" = "pink", "M" = "skyblue")) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 20),
        axis.title.y = element_text(size = 16),
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14),
        axis.text.x = element_text(size = 14),
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
          linewidth = 1
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
    
    compare_clicked(TRUE)  
    
    
    invalidateLater(100, session)  
    
    
    print(paste("Button clicked. TSH value: ", input$user_tsh)) 
    
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
                                     "This is <b>", normal_status, "</b> for your age group (", input$comparison_age_range, ").\n")
    
    output$comparison_message <- renderText({
      (user_comparison_message)
    })
  })
  
  
  
  reactive_age_range_t3 <- reactive({
    age_t3 <- input$user_age_t3
    
    if (age_t3 < 1) {
      return("Babies < 1")
    } else if (age_t3 >= 1 && age_t3 <= 6) {
      return("Children 1-6")
    } else if (age_t3 >= 7 && age_t3 <= 11) {
      return("Children 7-11")
    } else if (age_t3 >= 12 && age_t3 <= 17) {
      return("Ages 12-17")
    } else {
      return("Adults 18-99")
    }
  })
  
  observe({
    selected_range_t3 <- reactive_age_range_t3()
    
    updateSelectInput(session, "comparison_age_range_t3", selected = selected_range_t3)
  })
  
  
  compare_clicked_t3 <- reactiveVal(FALSE)
  
  observeEvent(input$compare_button_t3, {
    req(input$user_age_t3, input$user_t3)
    compare_clicked_t3(TRUE)
  })
  
  #normal Free T3 ranges
  normal_ranges_t3 <- list(
    "Babies < 1" = c(min = 1.4, max = 6.4),
    "Children 1-6" = c(min = 2.0, max = 6.0),
    "Children 7-11" = c(min = 2.7, max = 5.2),
    "Ages 12-17" = c(min = 2.3, max = 5.0),
    "Adults 18-99" = c(min = 2.3, max = 4.1)
  )
  
  
  filtered_data_t3 <- reactive({
    data_t3 <- thyroid_df_shiny[!is.na(thyroid_df_shiny$T3) & !is.na(thyroid_df_shiny$age), ]
    
    data_t3$age_group_t3 <- cut(data_t3$age,
                                breaks = c(-Inf, 1, 6, 11, 17, 99),
                                labels = c("Babies < 1", "Children 1-6", "Children 7-11", "Ages 12-17", "Adults 18-99"),
                                right = TRUE)
    
    data_t3 <- data_t3[abs(data_t3$T3 - input$t3_value) <= 1, ]
    
    if (input$sex_t3 != "All") {
      data_t3 <- data_t3[data_t3$sex == input$sex_t3, ]
    }
    
    return(data_t3)
  })
  
  #T3 histo 
  output$T3histogram <- renderPlot({
    data_t3 <- filtered_data_t3() 
    
    if (nrow(data_t3) == 0) {
      return(NULL)
    }
    
    plot_t3 <- ggplot(data_t3, aes(x = T3, fill = sex)) +
      geom_histogram(aes(y= ..density..), binwidth = 1, color = "black", alpha = 0.7, position = "dodge") +
      facet_wrap(~sex + age_group_t3, nrow = 2) +
      labs(title = paste("Histogram of T3 Levels Around", input$t3_value, "Across Different Age Ranges by Sex"),
           x = "T3 Level",
           y = "Proportion") +
      scale_fill_manual(values = c("F" = "pink", "M" = "skyblue")) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 20),
        axis.title.y = element_text(size = 16),
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14),
        axis.text.x = element_text(size = 14),
        plot.margin = margin(t = 30, b = 40),
        strip.text = element_text(size = 12, margin = margin(t = 10, b = 10)),
        panel.spacing = unit(2, "lines")
      )
    
    if (compare_clicked_t3()) {
      plot_t3 <- plot_t3 + 
        geom_vline(
          data = data_t3[data_t3$age_group_t3 == reactive_age_range_t3(), ],
          aes(xintercept = input$user_t3),
          color = "red", 
          linetype = "dashed", 
          linewidth = 1
        )
    }
    
    return(plot_t3)
  })
  
  output$no_labs_available_message_t3 <- renderText({
    data_t3 <- filtered_data_t3()
    
    if (nrow(data_t3) == 0) {
      return("No results matching that input.")
    } else {
      return(NULL)
    }
  })
  
  observeEvent(input$compare_button_t3, {
    req(input$user_age_t3, input$user_t3)
    
    compare_clicked_t3(TRUE) 
    
    
    
    
    print(paste("Button clicked. Free T3 value: ", input$user_t3)) 
    
    normal_range_t3 <- normal_ranges_t3[[input$comparison_age_range_t3]]
    normal_min_t3 <- normal_range_t3["min"]
    normal_max_t3 <- normal_range_t3["max"]
    
    normal_status_t3 <- "within range"
    if (input$user_t3 < normal_min_t3) {
      normal_status_t3 <- "lower than expected"
    } else if (input$user_t3 > normal_max_t3) {
      normal_status_t3 <- "higher than expected"
    }
    
    user_comparison_message_t3 <- paste("Your Free T3 value is ", input$user_t3, ".\n",
                                        "This is <b>", normal_status_t3, "</b> for your age group (", input$comparison_age_range_t3, ").\n")
    
    output$comparison_message_t3 <- renderText({
      user_comparison_message_t3
    })
  })
  
 
  
   reactive_age_range_t4 <- reactive({
    age_t4 <- input$user_age_t4
    
    if (age_t4 < 6) {
      return("Children < 6")
    } else if (age_t4 >= 6 && age_t4 <= 15) {
      return("Children 6-15")
    } else if (age_t4 >= 16 && age_t4 <= 17) {
      return("Adolescents 16-17")
    } else {
      return("Adults 18-99")
    }
  })
  
  observe({
    selected_range_t4 <- reactive_age_range_t4()
    
    updateSelectInput(session, "comparison_age_range_t4", selected = selected_range_t4)
  })
  
  
  compare_clicked_t4 <- reactiveVal(FALSE)
  
  observeEvent(input$compare_button_t4, {
    req(input$user_age_t4, input$user_t4)
    compare_clicked_t4(TRUE)
  })
  
  #normal T4 ranges
  normal_ranges_t4 <- list(
    "Children < 6" = c(min = 0.8, max = 2.8),
    "Children 6-15" = c(min = 0.8, max = 2.1),
    "Adolescents 16-17" = c(min = 0.8, max = 2.8),
    "Adults 18-99" = c(min = 0.9, max = 1.7)
  )
  
  
  filtered_data_t4 <- reactive({
    data_t4 <- thyroid_df_shiny[!is.na(thyroid_df_shiny$TT4) & !is.na(thyroid_df_shiny$age), ]
    
    data_t4$age_group_t4 <- cut(data_t4$age,
                                breaks = c(-Inf, 6, 15, 17, 99),
                                labels = c("Children < 6", "Children 6-15", "Adolescents 16-17", "Adults 18-99"),
                                right = TRUE)
    
    data_t4 <- data_t4[abs(data_t4$TT4 - input$t4_value) <= 1, ]
    
    if (input$sex_t4 != "All") {
      data_t4 <- data_t4[data_t4$sex == input$sex_t4, ]
    }
    
    return(data_t4)
  })
  
  #T4 histo
  output$T4histogram <- renderPlot({
    data_t4 <- filtered_data_t4() 
    
    if (nrow(data_t4) == 0) {
      return(NULL)
    }
    
    plot_t4 <- ggplot(data_t4, aes(x = TT4, fill = sex)) +
      geom_histogram(aes(y= ..density..), binwidth = 1, color = "black", alpha = 0.7, position = "dodge") +
      facet_wrap(~sex + age_group_t4, nrow = 2) +
      labs(title = paste("Histogram of T4 Levels Around", input$t4_value, "Across Different Age Ranges by Sex"),
           x = "T4 Level",
           y = "Proportion") +
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
    
    if (compare_clicked_t4()) {
      plot_t4 <- plot_t4 + 
        geom_vline(
          data = data_t4[data_t4$age_group_t4 == reactive_age_range_t4(), ],
          aes(xintercept = input$user_t4),
          color = "red", 
          linetype = "dashed", 
          linewidth = 1
        )
    }
    
    return(plot_t4)
  })
  
  output$no_labs_available_message_t4 <- renderText({
    data_t4 <- filtered_data_t4()
    
    if (nrow(data_t4) == 0) {
      return("No results matching that input.")
    } else {
      return(NULL)
    }
  })
  
  observeEvent(input$compare_button_t4, {
    req(input$user_age_t4, input$user_t4)
    
    compare_clicked_t4(TRUE) 
    
    
    
    
    print(paste("Button clicked. T4 value: ", input$user_t4)) 
    
    normal_range_t4 <- normal_ranges_t4[[input$comparison_age_range_t4]]
    normal_min_t4 <- normal_range_t4["min"]
    normal_max_t4 <- normal_range_t4["max"]
    
    normal_status_t4 <- "within range"
    if (input$user_t4 < normal_min_t4) {
      normal_status_t4 <- "lower than expected"
    } else if (input$user_t4 > normal_max_t4) {
      normal_status_t4 <- "higher than expected"
    }
    
    user_comparison_message_t4 <- paste("Your T4 value is ", input$user_t4, ".\n",
                                        "This is <b>", normal_status_t4, "</b> for your age group (", input$comparison_age_range_t4, ").\n")
    
    output$comparison_message_t4 <- renderText({
      user_comparison_message_t4
    })
  })
  
  diagnosis_check <- reactive({
    req(input$user_tsh, input$user_t3, input$user_t4, input$user_age)
    

    normal_range_tsh <- normal_ranges[[reactive_age_range()]]
    normal_range_t3 <- normal_ranges_t3[[reactive_age_range_t3()]]
    normal_range_t4 <- normal_ranges_t4[[reactive_age_range_t4()]]
    
    normal_min_tsh <- normal_range_tsh["min"]
    normal_max_tsh <- normal_range_tsh["max"]
    
    normal_min_t3 <- normal_range_t3["min"]
    normal_max_t3 <- normal_range_t3["max"]
    
    normal_min_t4 <- normal_range_t4["min"]
    normal_max_t4 <- normal_range_t4["max"]
    
    diagnosis <- "No diagnosis available, not enough information to conclude."
    
    if (input$user_tsh >= normal_min_tsh && input$user_tsh <= normal_max_tsh &&
        input$user_t3 >= normal_min_t3 && input$user_t3 <= normal_max_t3 &&
        input$user_t4 >= normal_min_t4 && input$user_t4 <= normal_max_t4) {
      diagnosis <- "No thyroid issues suspected. All values are within range."
    }
    
    if (input$user_tsh < normal_min_tsh && input$user_t3 > normal_max_t3 && input$user_t4 > normal_max_t4) {
      diagnosis <- "Suspected Hyperthyroidism."
    }
    
    if (input$user_tsh > normal_max_tsh && input$user_t3 < normal_min_t3 && input$user_t4 < normal_min_t4) {
      diagnosis <- "Suspected Hypothyroidism."
    }
    
    return(diagnosis)
  })
  
  
  output$diagnosis_output <- renderUI({
    diagnosis <- diagnosis_check()
    
    return(HTML(paste("<h4>Diagnosis: <strong>", diagnosis, "</strong></h4>", "<i>Please consult your physician for a formal diagnosis!</i>")))
  })
  
}
    
 





                                                                                                                             

                                                                                                                       
                                                                                                                       

                                       




