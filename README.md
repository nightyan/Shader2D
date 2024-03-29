Shader2D: 一些2D效果的Shader实现
===================================

Snapshot目录中是所有效果的截图或gif，可以先一睹为快。我是在unity 5.3.5p8中实现（目前已升级到unity 5.6.0f3），可用不低于此版本的unity打开查看。

- Blur        效果: 模糊         原理: 采样附近上下左右四个相邻像素的颜色，与当前像素颜色按比例混合（简单滤波）
- BlurBox     效果: box模糊      原理: 采样周边8个相邻像素的颜色，与当前像素颜色按平均比例混合（Box滤波器）
- BlurGauss   效果: 高斯模糊     原理: 采样周边8个相邻像素的颜色，与当前像素颜色按比例混合（高斯滤波器）
- Sharpen     效果: 拉普拉斯锐化 原理: 先将自身与周围的8个象素相减，表示自身与周围象素的差别，再将这个差别加上自身作为新象素的颜色
- RadialBlur  效果: 径向模糊     原理: 从中心点向外射线，当前点颜色为射线上多点采样混合所得。离中心点越近，采样越密集。

- CircleHole  效果: 圆形遮挡过场动画 原理: 圆形遮盖随时间缩小，用于过场动画

- EarthRotate 效果: 地球旋转动画 原理: 天空盒，UV动画。这个实现来自风宇冲的blog
       http://blog.sina.com.cn/lsy835375

- Emboss      效果: 浮雕         原理: 图像的前景前向凸出背景。把象素和左上方的象素进行求差运算，并加上一个灰度(背景)。
- Pencil      效果: 铅笔画描边   原理: 如果在图像的边缘处，灰度值肯定经过一个跳跃，我们可以计算出这个跳跃，并对这个值进行一些处理，来得到边缘浓黑的描边效果，就像铅笔画一样。

- Fade        效果: 渐隐         原理: 根据距离渐隐渐现

- Flash       效果: 闪光特效     原理: 叠加平行四边形亮光带，随时间运动划过图片，就像一束光带飘过

- Gray        效果: 灰化         原理: 0.3*R, 0.59*G, 0.11*B
- OldPhoto    效果: 老照片       原理: r = 0.393*r + 0.769*g + 0.189*b; g = 0.349*r + 0.686*g + 0.168*b; b = 0.272*r + 0.534*g + 0.131*b;

- OldTV       效果：旧电视       原理:噪点、失真、颜色偏移

- HexagonClip 效果: 正六边形裁剪 原理:

- Mosaic      效果: 马赛克       原理: n x n方块内取同一颜色

- InnerGlow   效果: 内发光       原理: 采样周边像素alpha取平均值，叠加发光效果
- OutterGlow  效果: 外发光       原理: 采样周边像素alpha取平均值，给外部加发光效果(1-col.a可避免内部发光)

- RoundRect   效果: 圆角         原理: 最简单的笨方法，效率差
- RoundCorner 效果: 同上         原理: 比较巧妙的算法，效率高。详见:
      http://www.cnblogs.com/jqm304775992/p/4987793.html

- Saturation  效果: 调整饱和度   原理: RGB转HSL，增加S再转回RGB

- SectorWarp  效果: 扇形映射     原理: 采样图片上的点，映射到一个扇形区域中

- SeqAnimate  效果: 序列帧动画   原理: 从mxn的动画图片中扣出当前帧动作图

- Shutter     效果: 百叶窗       原理: 划定窗页宽度，2张纹理间隔采样

- Twirl       效果: 旋转效果     原理: 旋转纹理UV坐标，越靠近中心旋转角度越大，越往外越小
- TwirlEffect 效果: 旋转效果     原理: 旋转纹理UV坐标。相比上一个，这个没有根据距离调整角度，并且演示了屏幕后处理特效
- Vortex      效果: 旋涡效果     原理: 旋转纹理UV坐标。相比Twirl，离中心越远，旋转角度越大。

- HDR         效果: HDR效果      原理: 让亮的地方更亮，同时为了过渡更平滑柔和，亮度采用高斯模糊后的亮度（灰度值）

- WaterColor  效果: 水彩画       原理: 随机采样周围颜色，模拟颜色扩散；然后把RGB由原来的8位量化为更低位，这样颜色的过渡就会显得不那么的平滑，呈现色块效果。

- Wave        效果: 波浪效果     原理: 让顶点的Y轴按正弦或余弦变化。

- WaterRipple 效果: 水滴波动效果 原理: 正弦波，越远波长越长，振幅越小。

-------------------------------------------------


参考
-----------------------------------
1. Java Image Filters     http://www.jhlabs.com/index.html   一款基于Java的图像处理类库，在图像滤镜特效方面，非常强大，几乎提供了PS上大部分的图像特效，比如反色、扭曲、水波等效果。本文一些效果的算法参考了此项目。

2. 数字图像处理  随便一本高校用的教材即可。

3. 其它一些参考已经在具体效果的原理中列出。如有遗漏请指出，谢谢。
