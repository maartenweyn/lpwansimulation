# lpwan simulation

A lot has already been written about Low Power Wide Area Networks and especially about LoraWAN and Sigfox.
There are various websites and blogs which explain the technologies but mostly using marketing arguments.
On this website, I want to start an open discussion about the real performance of both the technologies based on validated experiments and simulations.

Please feel free to contact me or share you feedback at the bottom of the website so I can update the page based on your input.

On this page I want to tackle different aspects of the technologies, the first one is capacity, i.e. the number of messages which can be send using the technology per minute by devices in the same vicinity.

## Updates
2016-04-14: limiting to SF12-7 instead of 6, as in the LoraWAN spec
2016-04-14: further discussion on this topic is done on https://www.thethingsnetwork.org/forum/t/universal-lora-wan-gateway-limitations-because-physics/1749/3


## Capacity
### LoRaWAN

In Europe LoraWAN has 3 125 kHz channels in the EU 863-870 MHz SRD band. The default channels are 868.10, 868.30 and 868.50 MHz, which all fall in the ERC Recommendation 70-03 g1 channel. ETSI regulations specify to use a 1% duty-cycle limitation or Listen Before Talk Adaptive Frequency Agility. The LoraWAN specification uses the duty-cycled limited transmissions, this mean that a maximum of totally 36 s can be transmitted by one node per hour. The default radiated transmit power is 14 dBm, but this can be lowered. The maximum radiated power - specified by ETSI - is 25 mW (= 14 dBm).

6 other channels are used for JoinRequest messages, in this article we will focus on the 3 data channels.

LoRa uses a modulation based on spread-spectrum techniques and a variation of chirp spread spectrum[1]. LoRaWAN specifies data rates for LoRA between 0.3 kbps to 22 kbps based on the spreading factor. The LoRaWAN network manages the used spreading factor and transmitted signal power to optimize performance and scalability This means that when the network has become too dense, new gateways can be added and the data rate and RF output power adapted (14, 11, 8, 5 and 2 dBm)

The relation between Spreading Factor (SF), equivalent bit rate and sensitivity is described in the Semtech AN1200[2]:

| Spreading Factor   | Equivalent bit rate (kb/s) | Sensitivity (dBm) |
| ------------------ | -------------------------- | ----------------- |
| 12	| 0.293	| -137 |
| 11	| 0.537 | 	 -134.5 |
| 10	| 0.976 | 	 -132 |
| 9	| 1.757	|  -129 |
| 8	| 3.125	|  -126 |
| 7	| 5.468 | 	 -123 |

In this article I will calculate what is the maximum number of messages which can be send using this 3 channels per unit time (minute).

According to Semtech AN1200 [2], LoRa can take advantage of the orthogonal spreading factors and simultaneously send messages with a different spreading factor can be received. For 1 125 kHz LoRa channels the maximum theoretical capacity is therefor:

![Capacity Lora](/images/capacity_lora.png)

Where SF6 is not required in the minimum set defined by the LoRaWAN specifications, so in that case 12.156 kb/s.


The image below shows a simulation of 500 random messages where every message consists only of 25 bytes (chosen to be compliant to experiment with Sigfox, longer packets will generate more collisions) and the device can choose a random SF (in order to optimize the simultaneous use of the spectrum). Green represents successful transmissions, red represents collision with the same SF and thus non successful reception of the message. The simulations only take into account devices that are in each others vicinity, meaning will interfere with each other. We will discuss the impact of the TX power later. The choice of the SF (which is chosen random here as can be shown in the graph) has of course an impact on the transmission time of the message.

![lora_spectrum_500_dev](/images/lora_spectrum_500_dev.png)

The next figure shows the relation of the number of collisions while sending up to 1000 (25 byte) messages / minute with a randomly chosen SF (between 12 en 7).

![lora_1000_dev_sf_12_7](/images/lora_1000_dev_sf_12_7.png)

If we look into an ideal case where we only use SF7, resulting a short message (36 ms).

![lora_1000_dev_sf_7_7](/images/lora_1000_dev_sf_7_7.png)

And the worst case (using SF12, resulting in 682 ms)

![lora_1000_dev_sf_12_12](/images/lora_1000_dev_sf_12_12.png)

### Sigfox
Sigfox sends 3 messages using on a random frequency within a 200 kHz band in the 868 SDR band. Sigfox uses 100Hz ultra-narrowband GFSK modulation.
The following simulation shows these 200 kHz when 1000 devices are transmitting within 1 minutes, in total 3000 messages are being send.

![sigfox_spectrum_1000_dev_3_tx](/images/sigfox_spectrum_1000_dev_3_tx.png)



This results in the graph below where the number of collisions are shown but only when the 3 messages of 1 devices are not received it will results in a failed transmission (packet error).

![sigfox_1000_dev_3_tx](/images/sigfox_1000_dev_3_tx.png)




If the redundancy is removed and only 1 message is send (hence less collisions but also less redundancy) this results in the following result.



![sigfox_1000_dev_1_tx](/images/sigfox_1000_dev_1_tx.png)



Let's look at the extreme case where up to 10000 devices will transmit within 1 minute.

![sigfox_10000_dev_3_tx](/images/sigfox_10000_dev_3_tx.png)



### Considerations
The above simulation only take into account the spectrum use around 1 gateway, of course multiple gateways can detect signals which will raise the packet delivery ratio. However, the above simulations show the limitation of the spectrum in a specific area.
Both technologies can use the maximum allowed transmit power defined by ETSI (14 dbm). A difference between LoraWAN and Sigfox is that the LoraWAN gateways can dictate the transmit power to the endnodes, limiting their range, of course this also means there is more download traffic to the nodes. And the downlink also has to take into account the 10% duty cycle. If we take e.g. the Hatta RF propagation model for urban environments and we limit for LoraWAN the transmission power to Z dbm, taking into account the sensitivity level of -123  dbm (as stated in the Semtech datasheets) for SF7 we have an estimated range of 0.860 km (in an urban environment,1.7km suburban), resulting in a coverage of 3 km² . Although you can of course define the output power of the Sigfox module it is not controlled by the network with a sensitivity  of -130 dbm and a TX power of 14 dbm the estimated urban range (using the Hatta model) is 3 km, using a TX power of 7 dbm the range is  1.9 km.

##Power Consumption
coming up soon...

##References

    Semtech LoRa FAQ
    Semtech AN1200.22 LoRa Modulation Basics
