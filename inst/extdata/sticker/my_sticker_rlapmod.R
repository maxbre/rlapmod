# https://github.com/GuangchuangYu/hexSticker
library(hexSticker)
library(ggplot2)

p<-ggplot(aes(x = mpg, y = wt), data = mtcars) +
  geom_point(aes(colour = factor(cyl)), show.legend = FALSE)+
  scale_color_viridis_d(option = "viridis")+
  theme_void() +
  theme_transparent()

p

s<-sticker(p, 
           package = "rlapmod", 
           p_color = "#1e81b0",
           p_size = 20, 
           p_x = 1,
           p_y = 1.5,
           s_x = 0.9,
           s_y = 0.8, 
           s_width = 1, 
           s_height = 1,
           spotlight = FALSE,
           l_width = 1.1,
           l_height = 1.1,
           l_alpha = 0.6,
           l_x = 0.48,
           l_y = 1.0,
           #h_fill = "#5DB5F8",
           h_fill = "#FFFFFF",
           #h_color = "#000080",
           h_color = "#1e81b0",
           filename="./rlapmod.png")

plot(s)


