function though2peak = waveform_vally2peak(wf,unit_id,ch_id)

    for k =1:length(unit_id)
    
    temp = wf{k};
    temp_wf = squeeze(temp.waveFormsMean(1,:,:));
    temp_wf_ch = temp_wf(ch_id(k)+1,:);
    
    [M,I] = min(temp_wf_ch);
    [M1,I1] = max(temp_wf_ch(I:end));
    
    though2peak(k) = double((I1)/30);
end

end