ui <- fluidPage(
  titlePanel("TSH and Free T3 Level Distribution by Age and Sex"),
  
  tabsetPanel(
    # Tab for TSH
    tabPanel("TSH Level Distribution", 
             sidebarLayout(
               sidebarPanel(
                 h3("Distribution of TSH Levels"),
                 numericInput("tsh_value", 
                              "Input TSH Value (in mU/L):", 
                              value = 2, 
                              min = 0, 
                              max = 530, 
                              step = 0.25),
                 p("Input TSH value."),
                 
                 radioButtons("sex", 
                              "Select Sex for Distribution:",
                              choices = c("All", "M", "F"), 
                              selected = "All"),
                 p("Use the buttons to filter by sex."),
                 
                 br(),
                 
                 h3("Compare Your TSH Level to others and see if it's within the Expected Range"),
                 numericInput("user_age", "Enter your age:", value = 30, min = 0, max = 120, step = 1),
                 numericInput("user_tsh", "Enter your TSH value:", value = 2, min = 0, max = 530, step = 0.1),
                 selectInput("comparison_age_range", 
                             "Age Range for Comparison (TSH):",
                             choices = c("Babies < 1", "Children 1-6", "Children 7-11", 
                                         "Ages 12-20", "Adults 21-99")),
                 actionButton("compare_button", "Compare to Others"),
                 br()
               ),
               
               mainPanel(
                 textOutput("no_labs_available_message"),
                 plotOutput("TSHhistogram"),
                 textOutput("comparison_message")  
               )
             )
    ),
    
    # Tab for T3
    tabPanel("Free T3 Level Distribution", 
             sidebarLayout(
               sidebarPanel(
                 h3("Distribution of Free T3 Levels"),
                 numericInput("t3_value", 
                              "Input Free T3 Value (in pg/mL):", 
                              value = 2.5, 
                              min = 0, 
                              max = 20, 
                              step = 0.1),
                 p("Input Free T3 value."),
                 
                 radioButtons("sex_t3", 
                              "Select Sex for Distribution:",
                              choices = c("All", "M", "F"), 
                              selected = "All"),
                 p("Use the buttons to filter by sex."),
                 
                 br(),
                 
                 h3("Compare Your Free T3 Level to others and see if it's within the Expected Range"),
                 numericInput("user_age_t3", "Enter your age:", value = 30, min = 0, max = 120, step = 1),
                 numericInput("user_t3", "Enter your T3 value:", value = 2.8, min = 0, max = 20, step = 0.1),
                 selectInput("comparison_age_range_t3", 
                             "Age Range for Comparison (T3):",
                             choices = c("Babies < 1", "Children 1-6", "Children 7-11", "Ages 12-17", "Adults 18-99")),
                 actionButton("compare_button_t3", "Compare to Others"),
                 br()
               ),
               
               mainPanel(
                 textOutput("no_labs_available_message_t3"),
                 plotOutput("T3histogram"),
                 textOutput("comparison_message_t3")  
               )
             )
    ),
    tabPanel("T4 Level Distribution", 
             sidebarLayout(
               sidebarPanel(
                 h3("Distribution of T4 Levels"),
                 numericInput("t4_value", 
                              "Input  T4 Value (in ng/dL):", 
                              value = 1.5, 
                              min = 0, 
                              max = 335, 
                              step = 0.1),
                 p("Input T4 value."),
                 
                 radioButtons("sex_t4", 
                              "Select Sex for Distribution:",
                              choices = c("All", "M", "F"), 
                              selected = "All"),
                 p("Use the buttons to filter by sex."),
                 
                 br(),
                 
                 h3("Compare Your T4 Level to others and see if it's within the Expected Range"),
                 numericInput("user_age_t4", "Enter your age:", value = 30, min = 0, max = 120, step = 1),
                 numericInput("user_t4", "Enter your T4 value:", value = 1.5, min = 0, max = 330, step = 0.1),
                 selectInput("comparison_age_range_t4", 
                             "Age Range for Comparison (T4):",
                             choices = c("Children < 6", "Children 6-15", "Adolescents 16-17", "Adults 18-99")),
                 actionButton("compare_button_t4", "Compare to Others"),
                 br()
               ),
               
               mainPanel(
                 textOutput("no_labs_available_message_t4"),
                 plotOutput("T4histogram"),
                 textOutput("comparison_message_t4")  
               )
             )
    )
  )
)







