spi = merge_spk.firing_range(unitid1);
[fp,xfp] = kde(spi);
[fc,xfc] = kde(spi,ProbabilityFcn="cdf");
plot(xfp,fp,"b-")

hold on
unitid1 = id{1};
unitid2 = id{2};
spi = merge_spk.firing_range(unitid2);
[fp,xfp] = kde(spi);
[fc,xfc] = kde(spi,ProbabilityFcn="cdf");
plot(xfp,fp,"r--")


[p,h,stats] = ranksum(merge_spk.firing_range(unitid1),merge_spk.firing_range(unitid2));
[h,p,ci,stats] = ttest2(merge_spk.test_stat_si(unitid1),merge_spk.test_stat_si(unitid2),"Tail","right");
[h,p,ci,stats] = ttest2(merge_spk.firing_range(unitid1),merge_spk.firing_range(unitid2));