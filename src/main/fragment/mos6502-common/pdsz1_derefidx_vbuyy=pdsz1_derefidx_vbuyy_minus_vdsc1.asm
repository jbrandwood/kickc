sec
lda ({z1}),y
sbc #<{c1}
sta ({z1}),y
iny
lda ({z1}),y
sbc #>{c1}
sta ({z1}),y
iny
lda ({z1}),y
sbc #<{c1}>>$10
sta ({z1}),y
iny
lda ({z1}),y
sbc #>{c1}>>$10
sta ({z1}),y