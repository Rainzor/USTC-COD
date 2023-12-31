# Amdahl's law and Gustafson's law

在[高并发](https://so.csdn.net/so/search?q=高并发&spm=1001.2101.3001.7020)程序设计中有两个非常重要的定律：

- Amdahl（阿姆达尔定律）
- Gustafson定律（古斯塔夫森定律）

这两个定律从不同的角度诠释了加速比与系统串行化程度、cpu核心数之间的关系，它们是我们在做高并发程序设计时的理论依据。

- 加速比

“加速比”是个什么鬼？先来看张图：
![这里写图片描述](https://img-blog.csdn.net/20180324002919850?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM0NTk0MjM2/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
串行程序为什么需要并行化，显然是为了提升系统的处理能力，即性能。并行化的过程，也可以称作系统优化的过程。上图中，在优化前，系统是完全串行的，步骤1至步骤5依次执行，共花费了500ms的时间；我们将步骤2与步骤5进行优化，使其分别用两个线程执行，每个线程各花费50ms，这样步骤2与5的执行时间就由优化前的100ms变为了优化后的50ms,那么整个程序在优化后的执行时间就缩短至400毫秒了,相当于系统的性能提升了20%。这个性能的提升可以用“加速比”来反应：

> 加速比=优化前系统耗时/优化后系统耗时

在上面的例子中，加速比=500/400=1.25，它是衡量系统优化程度的一个指标。

那么什么是阿姆达尔定律呢？

## Amdahl（阿姆达尔定律）

1. 阿姆达尔定律的定义
   阿姆达尔定律定义了串行系统并行化后加速比的计算公式与理论上限

2. 加速比的计算公式

   先来看优化后耗时与优化前耗时之间的关系，其公式为：

   $T_n=T_1(F+n(1−F))$

   其中定义n为处理器个数，T1为单核处理器时系统耗时即优化前系统耗时，Tn为n核心处理器系统时系统耗时即优化后系统耗时，F为串行比例，那么1-F就是并行比例了。

由前面的介绍可知：

加速比=优化前系统耗时优化后系统耗时加速比=优化前系统耗时优化后系统耗时


用T1与Tn来表示，“加速比”的计算公司可变为：

加速比=T1/Tn


将前面Tn的计算公式代入：

加速比=$\frac{T1}{T1(F+1n(1−F))}=\frac{1}{(F+1n(1−F)}$


这就是加速比的计算公式，从公式可以看出增加处理器的数量（提升n的值）并不一定能有效地提高加速比，如果系统的并行化程序不高，即F的值接近100%，就算n无穷大，加速比也是趋近于1的，并不会对系统的性能优化起到什么作用，而成本却无限增加了。

所以，我们可以从“加速比”的公式中看出，单纯地增加cup处理器的数量并不一定可以有效地提高系统的性能，只有在提高系统内并行化模块比重的前提下，同时合理增加处理器的数量，才能以最小的投入得到最大的加速比，这就是阿姆达尔定律要告诉我们的核心思想，它很直观地反应了加速比与处理器个数、系统串行比例之间的关系。

使用加速比的公式，我们同样可以计算出前方例子中的加速比是1.25，如下：

加速比=$1/(F+n(1−F))=1/(35+12(1−35))=135+15=54=1.25$

## Gustafson定律（古斯塔夫森定律）

Gustafson定律也是说明处理器个数、串行比例和加速比之前的关系，只不过它的侧重角度有所不同。

我们定义a为系统串行执行时间，b为系统并行执行时间，n为处理器个数，F为串行比例，那么系统执行时间（串行时间+并行时间）可以表示为a+b，系统总执行时间（串行时间）可以表示为a+nb,所以有如下公式推演：

执行时间=a+b

总执行时间=a+nb

加速比=$\frac{a+nb}{a+b}$


其中，串行比例 F=a/a+b，将其代入上面的公司，可得到：

加速比=$F+\frac{n(a+b−a)}{a+b}=F+n(1−\frac{a}{a+b})=F+n(1−F)=F+n−nF=n−F(n−1)$

最终的公式为：加速比= n+F(1-n)；
从公式中可以看出，F（串行化程度）足够小，也即并行化足够高，**那么加速比和cpu个数成正比。**