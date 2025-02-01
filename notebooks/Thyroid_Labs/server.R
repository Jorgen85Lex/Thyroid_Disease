function(input, output, session) {
  
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
  
  output$histogram <- renderPlot({
    data <- filtered_data()
    
    ggplot(data, aes(x = TSH, fill = sex)) +
      geom_histogram(binwidth = 1, color = "black", alpha = 0.7, position = "dodge") +
      facet_wrap(~ age_group, nrow = 1) +
      labs(title = paste("Histogram of TSH Levels Around", input$tsh_value, "Across Different Age Ranges by Sex"),
           x = "TSH Level",
           y = "Frequency") +
      scale_fill_manual(values = c("F"= "pink", "M"= "skyblue")) +
      theme_minimal()+
      theme(
        plot.title = element_text(size = 20),
        axis.title.y = element_text(size = 14),
        axis.text.y = element_text(size= 12),
        axis.text.x = element_text(size= 12),
        plot.margin = margin(t = 30, b = 40),
        strip.text = element_text(size = 12, margin = margin(t = 10, b = 10)),
        panel.spacing = unit(2, "lines")
      )
  })
}

