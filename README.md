# Statistical Projects by Jay Kim

The above files are projects that I have undertaken during my undergraduate career. The Browsing  and the Team_PKL files
were created for DataFest 2016 and DataFest 2017 respectively and were thus team efforts. 

## Data Visualization Projects

### Browsing and Purchasing Behavior Based on Device

The advent of the smartphone has changed our perspectives on visual and interactive media and has had important implications to marketing. For this project, my team and I attempted to understand this change in terms of browsing behaviors and how they affected purchasing patterns for the 2016 Vassar DataFest competition. Using data from TicketMaster, my team investigated the impact of platform devices, such as mobile and PC, and observed differential consumer behavior. For this competition, we had to clean ~ 10 GB of the file through data imputation and intentional deletion of irrelevant data to conduct the appropriate analyses. Some of the more interesting findings from this project were the changes of purchasing behavior between mobile and PC users as the days drew closer to the events in question, limited effect of paid vs. organic reach in attracting traffic flow, and the source flow of traffic from various devices.

### Market Segmentation Based on Browsing Activities and Seasonality of Hotel Bookings

What are the conscious and subconscious factors that go by when we make decisions about travel, be it that heavenly vacation to the Bahamas or a grinding 7 hour flight to London? My team decided to investigate this for the 2017 Vassar DataFest competition. Gathering data from Expedia, we performed multivariate regression, GIS visualization, and cluster analysis to identify particular groups of individuals and see what factors mattered the most to them. It appears that most people tend to book in the afternoon instead of the night and that there were two primary groups of individuals that could be most easily parsed: leisure vs. business travel. Seasonality by and large did not affect the behaviors of people (in aggregate), although it certainly affected the number of people booking travels. You can see with our Sankey diagrams (the weird flowing graphs) a nice representation of how the number and type of people that book change their behaviors according to hotel pricing and seasons.

## Academic/Statistic-Oriented Projects

### Social Identity on Depression

Depression is a complicated mental disorder with both genetic and environmental causes. For this project, I investigated (mostly) the social components of depression, looking at how one's conception of his/her/their identity affects the incidence of depression, using data from the 2007-2008 NHANES survey. I reclassified several of the survey data into relevant factors and classified variables under 3 separate submodels: Social Identity, Cultural Identity, and Economic Status. To identify whether an individual was clinically depressed, I created an index from 7 different variables under the Depression Screener survey. As expected, I observed that the variables classified under the social identity sub-model had the most impact on determining the morbidity of depression.

### Predicting Total Gross of Film

Is there a way to predict a film's success or failure before it is actually released? Scraping data from www.the-numbers.com/box-office-chart/weekend/2014/10/10, I attempted to understand some of the factors that may inform us of movie executives' decisions to release a particular movie at a certain date, and how they form their expectations. According to the data, it is the film's availability, based on its degree of distribution, that matters the most. Factors that one would expect to play an impact, such as the distributor's brand name, in fact played little into the film's total gross. I observed that the 'dump month theory', which states that films released during the winter months tend to be less successful than those in the summer and thus tend to be of lower quality (hence dumped into the winter), is somewhat validated by this data. Interestingly, although genres had a large impact on the film's total gross, they had poor predictive power and thus could not explain much of the variability within the data.


