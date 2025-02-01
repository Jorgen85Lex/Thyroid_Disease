function(input, output, session) {
  
  thyroid_df_shiny$age_group <- cut(thyroid_df_shiny$age,
                                    breaks = c(-Inf, 1, 6, 11, 20, 99),
                                    labels = c("Babies < 1", "Children 1-6", "Children 7-11", "People 12-20", "Adults 21-99"),
                                    right = TRUE)
  
  filtered_data <- reactive({
    data <- thyroid_df_shiny[!is.na(thyroid_df_shiny$TSH) & !is.na(thyroid_df_shiny$age), ]
    
    thyroid_df_shiny[abs(thyroid_df_shiny$TSH - input$tsh_value) <= 1, ]
  })
  
  output$histogram <- renderPlot({
    data <- filtered_data()
    
    ggplot(data, aes(x = TSH, fill = sex)) +
      geom_histogram(binwidth = 1, color = "black", alpha = 0.7, position = "dodge") +
      facet_wrap(~ age_group) +
      labs(title = paste("Histogram of TSH Levels Around", input$tsh_value, "Across Different Age Ranges by Sex"),
           x = "TSH Level",
           y = "Frequency") +
      scale_fill_manual(values = c("skyblue", "pink")) +
      theme_minimal()
  })
}

