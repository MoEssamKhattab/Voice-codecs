# Voice-codecs
A PCM-Based Vocoder/Decoder, a voice codec software based on PCM of voice signals to send over data network, whose quantizer provides both mid-rise and mid-tread quantization techniques, and an encoder with both Manchester and AMI signaling, providing the concept of AWGN channel, and regenerative repeaters.

## System

<figure>
<img src = "./figures/pcm-based-vocoder-decoder.png" title="PCM-based Vocoder/Decoder">
<figcaption align="center"><i>fig. 1 PCM-based Vocoder/Decoder</i></figcaption>
</figure>

## Requirements
A function for each of the system blocks is required as follows:
1. The Sampler function, with the required sampling frequency as input.

2. The Quantizer function should have the option that the user chooses between:

    * Mid-rise Uniform quantizer.
    * Mid-tread Uniform quantizer.

For each, the user specifies the number of levels, $L$, the peak quantization level, $m_p$.
The function should allow the user to input a signal to be quantized. That signal will be in the form of two vectors, a time vector and an amplitude vector.

This function should also result in the following:

* A figure showing the input signal and the quantized signal, on the same plot, with proper legend.

***Note:** Display the input signal as a continuous signal, and display the quantized signal as a continuous staircase signal.*

* The value of the mean square quantization error, i.e. $E\{(m − ν)^2\}$.

* A stream of bits representing the quantized signal.

3. The Encoder function is required to represent the bit stream resulting from the quantizer as a signal. This function should have the option that the user chooses between:

    * Manchester Signaling.
    * Alternate Mark Inversion Signaling.

For each, the user specifies the pulse amplitude and the bit duration.

***Note:** that the bit duration is related to the sampling rate and the number of bits of the Quantizer.*

4. The Decoder function is required to transform received PCM coded pulses into a stream of bits, then transform each $log_2(L)$ bits into a quantized sample.

This function should result in an output plot of the quantized samples.
This function should have parameters matching those of the Quantizer and Encoder functions.

---

## Test case I
### Modules Configuration
#### Sampler
- The required sampling rate, $f_s = 5 KHz$.
- The actual sampling rate after the downsampling, $F_s = 4.8 KHz$.

#### Quantizer
- Quantization Mode: Mid rise.
- Number of levels, $L = 256$.

#### Encoder
- Line Code: Manchester Signaling.
- Pulse Amplitude, $A = 5 volt$.
- Bit Rate, $Rb = 10K bit/sec$.

#### Channel (AWGN-channel)
- $Noise Power = 4 dB$.

---

### Results
#### Quantizer Output

<figure>
<img src = ".\figures\Midrise_Manchester,Fs=2.8k, L=256, Rb=10k, n=100, N0=4\input_sig_vs_quantized_sig.png" title="Input Signal vs. Quantized Signal">
<figcaption align=middle><i>fig. 2 Input Signal vs. Quantized Signal</i></figcaption>
</figure>


The following figure *(Fig. 3)* may show the output of the quantizer, and the difference between the input audio signal and the quantized signal more properly.


<figure align="center">
<img src = ".\figures\Midrise_Manchester,Fs=2.8k, L=256, Rb=10k, n=100, N0=4\input_sig_vs_quantized_sig_2.png" title="Input Signal vs. Quantized Signal">
<figcaption Align="center"><i>fig. 3 Input Signal vs. Quantized Signal</i></figcaption>
</figure>


**Bit stream *(first 20 bits)*:**

| 1 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |
|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|

---

#### Encoder Output
<figure>
<img src = ".\figures\Midrise_Manchester,Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Encoder_output.png" title="Encoder Output">
<figcaption Align="center"><i>fig. 4 Encoder Output</i></figcaption>
</figure>


We can see that the line code properly matches the the quantizer output bit stream.

---

#### Channel Output

<figure>
<img src = ".\figures\Midrise_Manchester,Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Channel_output.png" title="Channel Output">
<figcaption Align="center"><i>fig. 5 Channel Output</i></figcaption>
</figure>

---

#### Regenerative Repeater Output

<figure>
<img src = ".\figures\Midrise_Manchester,Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Regenerative_Repeater_output.png" title="Regenerative Repeater Output">
<figcaption Align="center"><i>fig. 6 Regenerative Repeater Output</i></figcaption>
</figure>


The regeneraative repeaters can successfully restore the PCM signal back from its noisy version. We can see that the output of the regenerative repeater is exactly the same as the output of the encoder.

---

#### Decoder Output

<figure>
<img src = ".\figures\Midrise_Manchester,Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Decoder_output.png" title="Decoder Output">
<figcaption Align="center"><i>fig. 7 Decoder Output (The Restored Signal)</i></figcaption>
</figure>


The following figure *(Fig. 8)* may show the output of the decoder, the restored signal, more properly.

<figure Align = "center">
<img src = ".\figures\Midrise_Manchester,Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Decoder_output_2.png" title="Decoder Output">
<figcaption Align="center"><i>fig. 8 Decoder Output (The Restored Signal)</i></figcaption>
</figure>

#### Output Audio Signal vs. Input Signal
| Input Signal | Output Signal |
| --- | --- |
| <video src="https://github.com/MoEssamKhattab/Voice-codecs/assets/95503706/f959a054-01f9-4a81-9f4e-97de8766b173"> | <video src="https://github.com/MoEssamKhattab/Voice-codecs/assets/95503706/ff339c19-6f3f-4764-83cd-0848ab8b36d0"> |

## Test case II
### Modules Configuration
#### Sampler
- The required sampling rate, $f_s = 5 KHz$.
- The actual sampling rate after the downsampling, $F_s = 4.8 KHz$.

#### Quantizer
- Quantization Mode: Mid tread.
- Number of levels: $L = 256$.

#### Encoder
- Line Code: AMI Signaling.
- Pulse Amplitude $A = 5 volt$.
- Bit Rate, $Rb = 10K bit/sec$.

#### Channel (AWGN-channel)
- $Noise Power = 4 dB$.
---
### Results
#### Quantizer Output

<figure>
<img src = ".\figures\Midtread_AMI, Fs=2.8k, L=256, Rb=10k, n=100, N0=4\input_sig_vs_quantized_sig.png" title="Input Signal vs. Quantized Signal">
<figcaption Align="center"><i>fig. 9 Input Signal vs. Quantized Signal</i></figcaption>
</figure>


The following figure *(Fig. 3)* may show the output of the quantizer, and the difference between the input audio signal and the quantized signal more properly.


<figure align="center">
<img src = ".\figures\Midtread_AMI, Fs=2.8k, L=256, Rb=10k, n=100, N0=4\input_sig_vs_quantized_sig_2.png" title="Input Signal vs. Quantized Signal">
<figcaption Align="center"><i>fig. 10 Input Signal vs. Quantized Signal</i></figcaption>
</figure>


**Bit stream *(first 20 bits)*:**

| 1 | 0 | 0 | 0 | 0 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 0 | 1 | 0 | 0 | 0 |
|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
---
#### Encoder Output
<figure>
<img src = ".\figures\Midtread_AMI, Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Encoder_output.png" title="Encoder Output">
<figcaption Align="center"><i>fig. 11 Encoder Output</i></figcaption>
</figure>


We can see that the line code properly matches the the quantizer output bit stream.

---

#### Channel Output

<figure>
<img src = ".\figures\Midtread_AMI, Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Channel_output.png" title="Channel Output">
<figcaption Align="center"><i>fig. 12 Channel Output</i></figcaption>
</figure>

---

#### Regenerative Repeater Output

<figure>
<img src = ".\figures\Midtread_AMI, Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Regenerative_Repeater_output.png" title="Regenerative Repeater Output">
<figcaption Align="center"><i>fig. 13 Regenerative Repeater Output</i></figcaption>
</figure>


The regeneraative repeaters can successfully restore the PCM signal back from its noisy version. We can see that the output of the regenerative repeater is exactly the same as the output of the encoder.

---

#### Decoder Output

<figure>
<img src = ".\figures\Midtread_AMI, Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Decoder_output.png" title="Decoder Output">
<figcaption Align="center"><i>fig. 14 Decoder Output (The Restored Signal)</i></figcaption>
</figure>


The following figure *(Fig. 15)* may show the output of the decoder, the restored signal, more properly.

<figure Align = "center">
<img src = ".\figures\Midtread_AMI, Fs=2.8k, L=256, Rb=10k, n=100, N0=4\Decoder_output_2.png" title="Decoder Output">
<figcaption Align="center"><i>fig. 15 Decoder Output (The Restored Signal)</i></figcaption>
</figure>

#### Output Audio Signal vs. Input Signal
| Input Signal | Output Signal |
| --- | --- |
| <video src="https://github.com/MoEssamKhattab/Voice-codecs/assets/95503706/f959a054-01f9-4a81-9f4e-97de8766b173"> | <video src="https://github.com/MoEssamKhattab/Voice-codecs/assets/95503706/ca91115c-302a-4559-b455-b433ff680e81"> |


The result in case of the mid-rise quantization technique with Manchester line code are the same as the case of mid-tred and AMI signaling.
