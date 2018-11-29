
kernel：     檔案格式 elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2e 10 80       	mov    $0x80102ee0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 60 6f 10 80       	push   $0x80106f60
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 e5 41 00 00       	call   80104240 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 6f 10 80       	push   $0x80106f67
80100097:	50                   	push   %eax
80100098:	e8 73 40 00 00       	call   80104110 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 b7 42 00 00       	call   801043a0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 e9 42 00 00       	call   80104450 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 3f 00 00       	call   80104150 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ed 1f 00 00       	call   80102170 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 6f 10 80       	push   $0x80106f6e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 3d 40 00 00       	call   801041f0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 a7 1f 00 00       	jmp    80102170 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 6f 10 80       	push   $0x80106f7f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 fc 3f 00 00       	call   801041f0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 3f 00 00       	call   801041b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 90 41 00 00       	call   801043a0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 ef 41 00 00       	jmp    80104450 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 6f 10 80       	push   $0x80106f86
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 2b 15 00 00       	call   801017b0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 0f 41 00 00       	call   801043a0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 ee 3a 00 00       	call   80103db0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 29 35 00 00       	call   80103800 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 65 41 00 00       	call   80104450 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 bd 13 00 00       	call   801016b0 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 05 41 00 00       	call   80104450 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 5d 13 00 00       	call   801016b0 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 e2 23 00 00       	call   80102770 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 8d 6f 10 80       	push   $0x80106f8d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 d7 78 10 80 	movl   $0x801078d7,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 a3 3e 00 00       	call   80104260 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 a1 6f 10 80       	push   $0x80106fa1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 f1 56 00 00       	call   80105b10 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 38 56 00 00       	call   80105b10 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 2c 56 00 00       	call   80105b10 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 20 56 00 00       	call   80105b10 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 37 40 00 00       	call   80104550 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 72 3f 00 00       	call   801044a0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 a5 6f 10 80       	push   $0x80106fa5
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 d0 6f 10 80 	movzbl -0x7fef9030(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 9c 11 00 00       	call   801017b0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 80 3d 00 00       	call   801043a0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 04 3e 00 00       	call   80104450 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 3e 3d 00 00       	call   80104450 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 b8 6f 10 80       	mov    $0x80106fb8,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 d3 3b 00 00       	call   801043a0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 bf 6f 10 80       	push   $0x80106fbf
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 98 3b 00 00       	call   801043a0 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 e3 3b 00 00       	call   80104450 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 65 36 00 00       	call   80103f60 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 d4 36 00 00       	jmp    80104050 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 c8 6f 10 80       	push   $0x80106fc8
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 8b 38 00 00       	call   80104240 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 42 19 00 00       	call   80102320 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 ff 2d 00 00       	call   80103800 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 c4 21 00 00       	call   80102bd0 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 29 15 00 00       	call   80101f40 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 83 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 92 0f 00 00       	call   801019d0 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 11 0f 00 00       	call   80101960 <iunlockput>
    end_op();
80100a4f:	e8 ec 21 00 00       	call   80102c40 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 27 62 00 00       	call   80106ca0 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 03 0f 00 00       	call   801019d0 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 e7 5f 00 00       	call   80106af0 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 f1 5e 00 00       	call   80106a30 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 c2 60 00 00       	call   80106c20 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 f1 0d 00 00       	call   80101960 <iunlockput>
  end_op();
80100b6f:	e8 cc 20 00 00       	call   80102c40 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 56 5f 00 00       	call   80106af0 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 6f 60 00 00       	call   80106c20 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 7d 20 00 00       	call   80102c40 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 e1 6f 10 80       	push   $0x80106fe1
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 4a 61 00 00       	call   80106d40 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 ae 3a 00 00       	call   801046e0 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 9b 3a 00 00       	call   801046e0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 5a 62 00 00       	call   80106eb0 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 f0 61 00 00       	call   80106eb0 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 9b 39 00 00       	call   801046a0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 6f 5b 00 00       	call   801068a0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 e7 5e 00 00       	call   80106c20 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 ed 6f 10 80       	push   $0x80106fed
80100d5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d60:	e8 db 34 00 00       	call   80104240 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d81:	e8 1a 36 00 00       	call   801043a0 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 9a 36 00 00       	call   80104450 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc8:	e8 83 36 00 00       	call   80104450 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 ff 10 80       	push   $0x8010ffc0
80100def:	e8 ac 35 00 00       	call   801043a0 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0c:	e8 3f 36 00 00       	call   80104450 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 f4 6f 10 80       	push   $0x80106ff4
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 5a 35 00 00       	call   801043a0 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 df 35 00 00       	jmp    80104450 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 b3 35 00 00       	call   80104450 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 aa 24 00 00       	call   80103370 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 fb 1c 00 00       	call   80102bd0 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 20 09 00 00       	call   80101800 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 51 1d 00 00       	jmp    80102c40 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 fc 6f 10 80       	push   $0x80106ffc
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 96 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 59 0a 00 00       	call   80101980 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 80 08 00 00       	call   801017b0 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 31 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 44 0a 00 00       	call   801019d0 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 0d 08 00 00       	call   801017b0 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 4e 25 00 00       	jmp    80103510 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 06 70 10 80       	push   $0x80107006
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 77 07 00 00       	call   801017b0 <iunlock>
      end_op();
80101039:	e8 02 1c 00 00       	call   80102c40 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 65 1b 00 00       	call   80102bd0 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 3a 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 48 0a 00 00       	call   80101ad0 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 13 07 00 00       	call   801017b0 <iunlock>
      end_op();
8010109d:	e8 9e 1b 00 00       	call   80102c40 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 2f 23 00 00       	jmp    80103410 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 0f 70 10 80       	push   $0x8010700f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 15 70 10 80       	push   $0x80107015
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 85 00 00 00    	je     8010119f <balloc+0x9f>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2d                	jmp    8010117a <balloc+0x7a>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
80101152:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101169:	85 d7                	test   %edx,%edi
8010116b:	74 43                	je     801011b0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116d:	83 c0 01             	add    $0x1,%eax
80101170:	83 c6 01             	add    $0x1,%esi
80101173:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101178:	74 05                	je     8010117f <balloc+0x7f>
8010117a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117d:	72 d1                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 75 e4             	pushl  -0x1c(%ebp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101197:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010119d:	77 82                	ja     80101121 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 1f 70 10 80       	push   $0x8010701f
801011a7:	e8 c4 f1 ff ff       	call   80100370 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	09 fa                	or     %edi,%edx
801011b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 ee 1b 00 00       	call   80102db0 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 b6 32 00 00       	call   801044a0 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 be 1b 00 00       	call   80102db0 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101225:	68 e0 09 11 80       	push   $0x801109e0
8010122a:	e8 71 31 00 00       	call   801043a0 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101250:	74 4e                	je     801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101268:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126a:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 d9 31 00 00       	call   80104450 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	75 b7                	jne    80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 e0 09 11 80       	push   $0x801109e0
801012bf:	e8 8c 31 00 00       	call   80104450 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 35 70 10 80       	push   $0x80107035
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 09             	cmp    $0x9,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 5a f6             	lea    -0xa(%edx),%ebx

  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 83 00 00 00    	ja     80101397 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 6a                	je     80101388 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 5e 1a 00 00       	call   80102db0 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101364:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 06                	mov    (%esi),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 71 fd ff ff       	call   80101100 <balloc>
8010138f:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
80101395:	eb 87                	jmp    8010131e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101397:	83 ec 0c             	sub    $0xc,%esp
8010139a:	68 45 70 10 80       	push   $0x80107045
8010139f:	e8 cc ef ff ff       	call   80100370 <panic>
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <readsb>:
struct superblock sb;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 7a 31 00 00       	call   80104550 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 c0 09 11 80       	push   $0x801109c0
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101423:	ba 01 00 00 00       	mov    $0x1,%edx
80101428:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142b:	c1 fb 03             	sar    $0x3,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 27                	je     80101463 <bfree+0x73>
8010143c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143e:	f7 d2                	not    %edx
80101440:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101442:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101445:	21 d0                	and    %edx,%eax
80101447:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010144b:	56                   	push   %esi
8010144c:	e8 5f 19 00 00       	call   80102db0 <log_write>
  brelse(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101463:	83 ec 0c             	sub    $0xc,%esp
80101466:	68 58 70 10 80       	push   $0x80107058
8010146b:	e8 00 ef ff ff       	call   80100370 <panic>

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	68 6b 70 10 80       	push   $0x8010706b
80101481:	68 e0 09 11 80       	push   $0x801109e0
80101486:	e8 b5 2d 00 00       	call   80104240 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 72 70 10 80       	push   $0x80107072
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 6c 2c 00 00       	call   80104110 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 c0 09 11 80       	push   $0x801109c0
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014c5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014cb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014d1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014d7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014dd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014e3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014e9:	68 d8 70 10 80       	push   $0x801070d8
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 b0 00 00 00    	jbe    801015cf <ialloc+0xcf>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 25                	jmp    8010154b <ialloc+0x4b>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->group = 1;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
      dip->group = 1;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101545:	0f 86 84 00 00 00    	jbe    801015cf <ialloc+0xcf>
    bp = bread(dev, IBLOCK(inum, sb));
8010154b:	89 d8                	mov    %ebx,%eax
8010154d:	83 ec 08             	sub    $0x8,%esp
80101550:	c1 e8 03             	shr    $0x3,%eax
80101553:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101559:	50                   	push   %eax
8010155a:	56                   	push   %esi
8010155b:	e8 70 eb ff ff       	call   801000d0 <bread>
80101560:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101562:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101564:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101567:	83 e0 07             	and    $0x7,%eax
8010156a:	c1 e0 06             	shl    $0x6,%eax
8010156d:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101571:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101575:	75 b9                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101577:	83 ec 04             	sub    $0x4,%esp
8010157a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010157d:	6a 40                	push   $0x40
8010157f:	6a 00                	push   $0x0
80101581:	51                   	push   %ecx
80101582:	e8 19 2f 00 00       	call   801044a0 <memset>
      dip->type = type;
80101587:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010158b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      dip->permission = 0x700;
      dip->owner = 99;
8010158e:	ba 63 00 00 00       	mov    $0x63,%edx
80101593:	66 89 51 38          	mov    %dx,0x38(%ecx)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
80101597:	66 89 01             	mov    %ax,(%ecx)
      dip->permission = 0x700;
8010159a:	b8 00 07 00 00       	mov    $0x700,%eax
8010159f:	66 89 41 3c          	mov    %ax,0x3c(%ecx)
      dip->owner = 99;
      dip->group = 1;
801015a3:	b8 01 00 00 00       	mov    $0x1,%eax
801015a8:	66 89 41 3a          	mov    %ax,0x3a(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ac:	89 3c 24             	mov    %edi,(%esp)
801015af:	e8 fc 17 00 00       	call   80102db0 <log_write>
      brelse(bp);
801015b4:	89 3c 24             	mov    %edi,(%esp)
801015b7:	e8 24 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bc:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
      dip->permission = 0x700;
      dip->owner = 99;
      dip->group = 1;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015c2:	89 da                	mov    %ebx,%edx
801015c4:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c6:	5b                   	pop    %ebx
801015c7:	5e                   	pop    %esi
801015c8:	5f                   	pop    %edi
801015c9:	5d                   	pop    %ebp
      dip->permission = 0x700;
      dip->owner = 99;
      dip->group = 1;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ca:	e9 41 fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015cf:	83 ec 0c             	sub    $0xc,%esp
801015d2:	68 78 70 10 80       	push   $0x80107078
801015d7:	e8 94 ed ff ff       	call   80100370 <panic>
801015dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015e0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->size = ip->size;

  dip->owner = ip->owner;
  dip->group = ip->group;
  dip->permission = ip->permission;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->size = ip->size;

  dip->owner = ip->owner;
  dip->group = ip->group;
  dip->permission = ip->permission;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->size = ip->size;

  dip->owner = ip->owner;
  dip->group = ip->group;
  dip->permission = ip->permission;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)

  dip->owner = ip->owner;
8010163d:	0f b7 53 2c          	movzwl 0x2c(%ebx),%edx
80101641:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  dip->group = ip->group;
80101645:	0f b7 53 2e          	movzwl 0x2e(%ebx),%edx
80101649:	66 89 50 2e          	mov    %dx,0x2e(%eax)
  dip->permission = ip->permission;
8010164d:	0f b7 53 30          	movzwl 0x30(%ebx),%edx
80101651:	66 89 50 30          	mov    %dx,0x30(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101655:	6a 2c                	push   $0x2c
80101657:	53                   	push   %ebx
80101658:	50                   	push   %eax
80101659:	e8 f2 2e 00 00       	call   80104550 <memmove>
  log_write(bp);
8010165e:	89 34 24             	mov    %esi,(%esp)
80101661:	e8 4a 17 00 00       	call   80102db0 <log_write>
  brelse(bp);
80101666:	89 75 08             	mov    %esi,0x8(%ebp)
80101669:	83 c4 10             	add    $0x10,%esp
}
8010166c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010166f:	5b                   	pop    %ebx
80101670:	5e                   	pop    %esi
80101671:	5d                   	pop    %ebp
  dip->owner = ip->owner;
  dip->group = ip->group;
  dip->permission = ip->permission;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101672:	e9 69 eb ff ff       	jmp    801001e0 <brelse>
80101677:	89 f6                	mov    %esi,%esi
80101679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101680 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 10             	sub    $0x10,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	68 e0 09 11 80       	push   $0x801109e0
8010168f:	e8 0c 2d 00 00       	call   801043a0 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010169f:	e8 ac 2d 00 00       	call   80104450 <release>
  return ip;
}
801016a4:	89 d8                	mov    %ebx,%eax
801016a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016a9:	c9                   	leave  
801016aa:	c3                   	ret    
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016b8:	85 db                	test   %ebx,%ebx
801016ba:	0f 84 d8 00 00 00    	je     80101798 <ilock+0xe8>
801016c0:	8b 53 08             	mov    0x8(%ebx),%edx
801016c3:	85 d2                	test   %edx,%edx
801016c5:	0f 8e cd 00 00 00    	jle    80101798 <ilock+0xe8>
    panic("ilock");

  acquiresleep(&ip->lock);
801016cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ce:	83 ec 0c             	sub    $0xc,%esp
801016d1:	50                   	push   %eax
801016d2:	e8 79 2a 00 00       	call   80104150 <acquiresleep>

  if(ip->valid == 0){
801016d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	85 c0                	test   %eax,%eax
801016df:	74 0f                	je     801016f0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e4:	5b                   	pop    %ebx
801016e5:	5e                   	pop    %esi
801016e6:	5d                   	pop    %ebp
801016e7:	c3                   	ret    
801016e8:	90                   	nop
801016e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f0:	8b 43 04             	mov    0x4(%ebx),%eax
801016f3:	83 ec 08             	sub    $0x8,%esp
801016f6:	c1 e8 03             	shr    $0x3,%eax
801016f9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ff:	50                   	push   %eax
80101700:	ff 33                	pushl  (%ebx)
80101702:	e8 c9 e9 ff ff       	call   801000d0 <bread>
80101707:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101709:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->size = dip->size;

    ip->owner = dip->owner;
    ip->group = dip->group;
    ip->permission = dip->permission;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101719:	0f b7 10             	movzwl (%eax),%edx
    ip->size = dip->size;

    ip->owner = dip->owner;
    ip->group = dip->group;
    ip->permission = dip->permission;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010171f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101723:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101727:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010172b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010172f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101733:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101737:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010173b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010173e:	89 53 58             	mov    %edx,0x58(%ebx)

    ip->owner = dip->owner;
80101741:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80101745:	66 89 93 88 00 00 00 	mov    %dx,0x88(%ebx)
    ip->group = dip->group;
8010174c:	0f b7 50 2e          	movzwl 0x2e(%eax),%edx
80101750:	66 89 93 8a 00 00 00 	mov    %dx,0x8a(%ebx)
    ip->permission = dip->permission;
80101757:	0f b7 50 30          	movzwl 0x30(%eax),%edx
8010175b:	66 89 93 8c 00 00 00 	mov    %dx,0x8c(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101762:	6a 2c                	push   $0x2c
80101764:	50                   	push   %eax
80101765:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101768:	50                   	push   %eax
80101769:	e8 e2 2d 00 00       	call   80104550 <memmove>
    brelse(bp);
8010176e:	89 34 24             	mov    %esi,(%esp)
80101771:	e8 6a ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101776:	83 c4 10             	add    $0x10,%esp
80101779:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->owner = dip->owner;
    ip->group = dip->group;
    ip->permission = dip->permission;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010177e:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101785:	0f 85 56 ff ff ff    	jne    801016e1 <ilock+0x31>
      panic("ilock: no type");
8010178b:	83 ec 0c             	sub    $0xc,%esp
8010178e:	68 90 70 10 80       	push   $0x80107090
80101793:	e8 d8 eb ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101798:	83 ec 0c             	sub    $0xc,%esp
8010179b:	68 8a 70 10 80       	push   $0x8010708a
801017a0:	e8 cb eb ff ff       	call   80100370 <panic>
801017a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017b0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017b8:	85 db                	test   %ebx,%ebx
801017ba:	74 28                	je     801017e4 <iunlock+0x34>
801017bc:	8d 73 0c             	lea    0xc(%ebx),%esi
801017bf:	83 ec 0c             	sub    $0xc,%esp
801017c2:	56                   	push   %esi
801017c3:	e8 28 2a 00 00       	call   801041f0 <holdingsleep>
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 c0                	test   %eax,%eax
801017cd:	74 15                	je     801017e4 <iunlock+0x34>
801017cf:	8b 43 08             	mov    0x8(%ebx),%eax
801017d2:	85 c0                	test   %eax,%eax
801017d4:	7e 0e                	jle    801017e4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
801017d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017dc:	5b                   	pop    %ebx
801017dd:	5e                   	pop    %esi
801017de:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017df:	e9 cc 29 00 00       	jmp    801041b0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017e4:	83 ec 0c             	sub    $0xc,%esp
801017e7:	68 9f 70 10 80       	push   $0x8010709f
801017ec:	e8 7f eb ff ff       	call   80100370 <panic>
801017f1:	eb 0d                	jmp    80101800 <iput>
801017f3:	90                   	nop
801017f4:	90                   	nop
801017f5:	90                   	nop
801017f6:	90                   	nop
801017f7:	90                   	nop
801017f8:	90                   	nop
801017f9:	90                   	nop
801017fa:	90                   	nop
801017fb:	90                   	nop
801017fc:	90                   	nop
801017fd:	90                   	nop
801017fe:	90                   	nop
801017ff:	90                   	nop

80101800 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	53                   	push   %ebx
80101806:	83 ec 28             	sub    $0x28,%esp
80101809:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010180c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010180f:	57                   	push   %edi
80101810:	e8 3b 29 00 00       	call   80104150 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101815:	8b 56 4c             	mov    0x4c(%esi),%edx
80101818:	83 c4 10             	add    $0x10,%esp
8010181b:	85 d2                	test   %edx,%edx
8010181d:	74 07                	je     80101826 <iput+0x26>
8010181f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101824:	74 32                	je     80101858 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101826:	83 ec 0c             	sub    $0xc,%esp
80101829:	57                   	push   %edi
8010182a:	e8 81 29 00 00       	call   801041b0 <releasesleep>

  acquire(&icache.lock);
8010182f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101836:	e8 65 2b 00 00       	call   801043a0 <acquire>
  ip->ref--;
8010183b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010183f:	83 c4 10             	add    $0x10,%esp
80101842:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101849:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010184c:	5b                   	pop    %ebx
8010184d:	5e                   	pop    %esi
8010184e:	5f                   	pop    %edi
8010184f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101850:	e9 fb 2b 00 00       	jmp    80104450 <release>
80101855:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101858:	83 ec 0c             	sub    $0xc,%esp
8010185b:	68 e0 09 11 80       	push   $0x801109e0
80101860:	e8 3b 2b 00 00       	call   801043a0 <acquire>
    int r = ip->ref;
80101865:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101868:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010186f:	e8 dc 2b 00 00       	call   80104450 <release>
    if(r == 1){
80101874:	83 c4 10             	add    $0x10,%esp
80101877:	83 fb 01             	cmp    $0x1,%ebx
8010187a:	75 aa                	jne    80101826 <iput+0x26>
8010187c:	8d 8e 84 00 00 00    	lea    0x84(%esi),%ecx
80101882:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101885:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101888:	89 cf                	mov    %ecx,%edi
8010188a:	eb 0b                	jmp    80101897 <iput+0x97>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101890:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101893:	39 fb                	cmp    %edi,%ebx
80101895:	74 19                	je     801018b0 <iput+0xb0>
    if(ip->addrs[i]){
80101897:	8b 13                	mov    (%ebx),%edx
80101899:	85 d2                	test   %edx,%edx
8010189b:	74 f3                	je     80101890 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010189d:	8b 06                	mov    (%esi),%eax
8010189f:	e8 4c fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
801018a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801018aa:	eb e4                	jmp    80101890 <iput+0x90>
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018b0:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
801018b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018b9:	85 c0                	test   %eax,%eax
801018bb:	75 33                	jne    801018f0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018bd:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018c0:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018c7:	56                   	push   %esi
801018c8:	e8 13 fd ff ff       	call   801015e0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801018cd:	31 c0                	xor    %eax,%eax
801018cf:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018d3:	89 34 24             	mov    %esi,(%esp)
801018d6:	e8 05 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
801018db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018e2:	83 c4 10             	add    $0x10,%esp
801018e5:	e9 3c ff ff ff       	jmp    80101826 <iput+0x26>
801018ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018f0:	83 ec 08             	sub    $0x8,%esp
801018f3:	50                   	push   %eax
801018f4:	ff 36                	pushl  (%esi)
801018f6:	e8 d5 e7 ff ff       	call   801000d0 <bread>
801018fb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101901:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101904:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101907:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010190a:	83 c4 10             	add    $0x10,%esp
8010190d:	89 cf                	mov    %ecx,%edi
8010190f:	eb 0e                	jmp    8010191f <iput+0x11f>
80101911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101918:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
8010191b:	39 fb                	cmp    %edi,%ebx
8010191d:	74 0f                	je     8010192e <iput+0x12e>
      if(a[j])
8010191f:	8b 13                	mov    (%ebx),%edx
80101921:	85 d2                	test   %edx,%edx
80101923:	74 f3                	je     80101918 <iput+0x118>
        bfree(ip->dev, a[j]);
80101925:	8b 06                	mov    (%esi),%eax
80101927:	e8 c4 fa ff ff       	call   801013f0 <bfree>
8010192c:	eb ea                	jmp    80101918 <iput+0x118>
    }
    brelse(bp);
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	ff 75 e4             	pushl  -0x1c(%ebp)
80101934:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101937:	e8 a4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010193c:	8b 96 84 00 00 00    	mov    0x84(%esi),%edx
80101942:	8b 06                	mov    (%esi),%eax
80101944:	e8 a7 fa ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101949:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80101950:	00 00 00 
80101953:	83 c4 10             	add    $0x10,%esp
80101956:	e9 62 ff ff ff       	jmp    801018bd <iput+0xbd>
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	53                   	push   %ebx
80101964:	83 ec 10             	sub    $0x10,%esp
80101967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010196a:	53                   	push   %ebx
8010196b:	e8 40 fe ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101970:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101973:	83 c4 10             	add    $0x10,%esp
}
80101976:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101979:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010197a:	e9 81 fe ff ff       	jmp    80101800 <iput>
8010197f:	90                   	nop

80101980 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	8b 55 08             	mov    0x8(%ebp),%edx
80101986:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101989:	8b 0a                	mov    (%edx),%ecx
8010198b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010198e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101991:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101994:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101998:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010199b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010199f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019a3:	8b 4a 58             	mov    0x58(%edx),%ecx
801019a6:	89 48 10             	mov    %ecx,0x10(%eax)

  st->owner = ip->owner;
801019a9:	0f b7 8a 88 00 00 00 	movzwl 0x88(%edx),%ecx
801019b0:	66 89 48 14          	mov    %cx,0x14(%eax)
  st->group = ip->group;
801019b4:	0f b7 8a 8a 00 00 00 	movzwl 0x8a(%edx),%ecx
801019bb:	66 89 48 16          	mov    %cx,0x16(%eax)
  st->permission = ip->permission;
801019bf:	0f b7 92 8c 00 00 00 	movzwl 0x8c(%edx),%edx
801019c6:	66 89 50 18          	mov    %dx,0x18(%eax)
}
801019ca:	5d                   	pop    %ebp
801019cb:	c3                   	ret    
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 1c             	sub    $0x1c,%esp
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801019df:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019e2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019e7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019ea:	8b 7d 14             	mov    0x14(%ebp),%edi
801019ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019f3:	0f 84 a7 00 00 00    	je     80101aa0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019fc:	8b 40 58             	mov    0x58(%eax),%eax
801019ff:	39 f0                	cmp    %esi,%eax
80101a01:	0f 82 c1 00 00 00    	jb     80101ac8 <readi+0xf8>
80101a07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a0a:	89 fa                	mov    %edi,%edx
80101a0c:	01 f2                	add    %esi,%edx
80101a0e:	0f 82 b4 00 00 00    	jb     80101ac8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a14:	89 c1                	mov    %eax,%ecx
80101a16:	29 f1                	sub    %esi,%ecx
80101a18:	39 d0                	cmp    %edx,%eax
80101a1a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a1d:	31 ff                	xor    %edi,%edi
80101a1f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a24:	74 6d                	je     80101a93 <readi+0xc3>
80101a26:	8d 76 00             	lea    0x0(%esi),%esi
80101a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a30:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a33:	89 f2                	mov    %esi,%edx
80101a35:	c1 ea 09             	shr    $0x9,%edx
80101a38:	89 d8                	mov    %ebx,%eax
80101a3a:	e8 a1 f8 ff ff       	call   801012e0 <bmap>
80101a3f:	83 ec 08             	sub    $0x8,%esp
80101a42:	50                   	push   %eax
80101a43:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a45:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a4a:	e8 81 e6 ff ff       	call   801000d0 <bread>
80101a4f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a54:	89 f1                	mov    %esi,%ecx
80101a56:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101a5c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101a5f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a62:	29 cb                	sub    %ecx,%ebx
80101a64:	29 f8                	sub    %edi,%eax
80101a66:	39 c3                	cmp    %eax,%ebx
80101a68:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a6b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101a6f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a70:	01 df                	add    %ebx,%edi
80101a72:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a74:	50                   	push   %eax
80101a75:	ff 75 e0             	pushl  -0x20(%ebp)
80101a78:	e8 d3 2a 00 00       	call   80104550 <memmove>
    brelse(bp);
80101a7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a80:	89 14 24             	mov    %edx,(%esp)
80101a83:	e8 58 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a88:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a8b:	83 c4 10             	add    $0x10,%esp
80101a8e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a91:	77 9d                	ja     80101a30 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a99:	5b                   	pop    %ebx
80101a9a:	5e                   	pop    %esi
80101a9b:	5f                   	pop    %edi
80101a9c:	5d                   	pop    %ebp
80101a9d:	c3                   	ret    
80101a9e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101aa0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101aa4:	66 83 f8 09          	cmp    $0x9,%ax
80101aa8:	77 1e                	ja     80101ac8 <readi+0xf8>
80101aaa:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ab1:	85 c0                	test   %eax,%eax
80101ab3:	74 13                	je     80101ac8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ab5:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101abb:	5b                   	pop    %ebx
80101abc:	5e                   	pop    %esi
80101abd:	5f                   	pop    %edi
80101abe:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101abf:	ff e0                	jmp    *%eax
80101ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101acd:	eb c7                	jmp    80101a96 <readi+0xc6>
80101acf:	90                   	nop

80101ad0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	53                   	push   %ebx
80101ad6:	83 ec 1c             	sub    $0x1c,%esp
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101adf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ae2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ae7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aea:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aed:	8b 75 10             	mov    0x10(%ebp),%esi
80101af0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af3:	0f 84 b7 00 00 00    	je     80101bb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101af9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afc:	39 70 58             	cmp    %esi,0x58(%eax)
80101aff:	0f 82 eb 00 00 00    	jb     80101bf0 <writei+0x120>
80101b05:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b08:	89 f8                	mov    %edi,%eax
80101b0a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b0c:	3d 00 14 01 00       	cmp    $0x11400,%eax
80101b11:	0f 87 d9 00 00 00    	ja     80101bf0 <writei+0x120>
80101b17:	39 c6                	cmp    %eax,%esi
80101b19:	0f 87 d1 00 00 00    	ja     80101bf0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b1f:	85 ff                	test   %edi,%edi
80101b21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b28:	74 78                	je     80101ba2 <writei+0xd2>
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b30:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b33:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b35:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b3a:	c1 ea 09             	shr    $0x9,%edx
80101b3d:	89 f8                	mov    %edi,%eax
80101b3f:	e8 9c f7 ff ff       	call   801012e0 <bmap>
80101b44:	83 ec 08             	sub    $0x8,%esp
80101b47:	50                   	push   %eax
80101b48:	ff 37                	pushl  (%edi)
80101b4a:	e8 81 e5 ff ff       	call   801000d0 <bread>
80101b4f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b54:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101b57:	89 f1                	mov    %esi,%ecx
80101b59:	83 c4 0c             	add    $0xc,%esp
80101b5c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101b62:	29 cb                	sub    %ecx,%ebx
80101b64:	39 c3                	cmp    %eax,%ebx
80101b66:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b69:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101b6d:	53                   	push   %ebx
80101b6e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b71:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b73:	50                   	push   %eax
80101b74:	e8 d7 29 00 00       	call   80104550 <memmove>
    log_write(bp);
80101b79:	89 3c 24             	mov    %edi,(%esp)
80101b7c:	e8 2f 12 00 00       	call   80102db0 <log_write>
    brelse(bp);
80101b81:	89 3c 24             	mov    %edi,(%esp)
80101b84:	e8 57 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b89:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b8c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b8f:	83 c4 10             	add    $0x10,%esp
80101b92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b95:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b98:	77 96                	ja     80101b30 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9d:	3b 70 58             	cmp    0x58(%eax),%esi
80101ba0:	77 36                	ja     80101bd8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ba2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba8:	5b                   	pop    %ebx
80101ba9:	5e                   	pop    %esi
80101baa:	5f                   	pop    %edi
80101bab:	5d                   	pop    %ebp
80101bac:	c3                   	ret    
80101bad:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bb4:	66 83 f8 09          	cmp    $0x9,%ax
80101bb8:	77 36                	ja     80101bf0 <writei+0x120>
80101bba:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bc1:	85 c0                	test   %eax,%eax
80101bc3:	74 2b                	je     80101bf0 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bc5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bcf:	ff e0                	jmp    *%eax
80101bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bdb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bde:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101be1:	50                   	push   %eax
80101be2:	e8 f9 f9 ff ff       	call   801015e0 <iupdate>
80101be7:	83 c4 10             	add    $0x10,%esp
80101bea:	eb b6                	jmp    80101ba2 <writei+0xd2>
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf5:	eb ae                	jmp    80101ba5 <writei+0xd5>
80101bf7:	89 f6                	mov    %esi,%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c06:	6a 0e                	push   $0xe
80101c08:	ff 75 0c             	pushl  0xc(%ebp)
80101c0b:	ff 75 08             	pushl  0x8(%ebp)
80101c0e:	e8 bd 29 00 00       	call   801045d0 <strncmp>
}
80101c13:	c9                   	leave  
80101c14:	c3                   	ret    
80101c15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 1c             	sub    $0x1c,%esp
80101c29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c31:	0f 85 80 00 00 00    	jne    80101cb7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c37:	8b 53 58             	mov    0x58(%ebx),%edx
80101c3a:	31 ff                	xor    %edi,%edi
80101c3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c3f:	85 d2                	test   %edx,%edx
80101c41:	75 0d                	jne    80101c50 <dirlookup+0x30>
80101c43:	eb 5b                	jmp    80101ca0 <dirlookup+0x80>
80101c45:	8d 76 00             	lea    0x0(%esi),%esi
80101c48:	83 c7 10             	add    $0x10,%edi
80101c4b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c4e:	76 50                	jbe    80101ca0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c50:	6a 10                	push   $0x10
80101c52:	57                   	push   %edi
80101c53:	56                   	push   %esi
80101c54:	53                   	push   %ebx
80101c55:	e8 76 fd ff ff       	call   801019d0 <readi>
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	83 f8 10             	cmp    $0x10,%eax
80101c60:	75 48                	jne    80101caa <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101c62:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c67:	74 df                	je     80101c48 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c69:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c6c:	83 ec 04             	sub    $0x4,%esp
80101c6f:	6a 0e                	push   $0xe
80101c71:	50                   	push   %eax
80101c72:	ff 75 0c             	pushl  0xc(%ebp)
80101c75:	e8 56 29 00 00       	call   801045d0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c7a:	83 c4 10             	add    $0x10,%esp
80101c7d:	85 c0                	test   %eax,%eax
80101c7f:	75 c7                	jne    80101c48 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c81:	8b 45 10             	mov    0x10(%ebp),%eax
80101c84:	85 c0                	test   %eax,%eax
80101c86:	74 05                	je     80101c8d <dirlookup+0x6d>
        *poff = off;
80101c88:	8b 45 10             	mov    0x10(%ebp),%eax
80101c8b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c8d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c91:	8b 03                	mov    (%ebx),%eax
80101c93:	e8 78 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
80101c9f:	c3                   	ret    
80101ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101ca3:	31 c0                	xor    %eax,%eax
}
80101ca5:	5b                   	pop    %ebx
80101ca6:	5e                   	pop    %esi
80101ca7:	5f                   	pop    %edi
80101ca8:	5d                   	pop    %ebp
80101ca9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101caa:	83 ec 0c             	sub    $0xc,%esp
80101cad:	68 b9 70 10 80       	push   $0x801070b9
80101cb2:	e8 b9 e6 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101cb7:	83 ec 0c             	sub    $0xc,%esp
80101cba:	68 a7 70 10 80       	push   $0x801070a7
80101cbf:	e8 ac e6 ff ff       	call   80100370 <panic>
80101cc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101cd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	56                   	push   %esi
80101cd5:	53                   	push   %ebx
80101cd6:	89 cf                	mov    %ecx,%edi
80101cd8:	89 c3                	mov    %eax,%ebx
80101cda:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cdd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ce3:	0f 84 53 01 00 00    	je     80101e3c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ce9:	e8 12 1b 00 00       	call   80103800 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cee:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cf1:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cf4:	68 e0 09 11 80       	push   $0x801109e0
80101cf9:	e8 a2 26 00 00       	call   801043a0 <acquire>
  ip->ref++;
80101cfe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d02:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d09:	e8 42 27 00 00       	call   80104450 <release>
80101d0e:	83 c4 10             	add    $0x10,%esp
80101d11:	eb 08                	jmp    80101d1b <namex+0x4b>
80101d13:	90                   	nop
80101d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d18:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d1b:	0f b6 03             	movzbl (%ebx),%eax
80101d1e:	3c 2f                	cmp    $0x2f,%al
80101d20:	74 f6                	je     80101d18 <namex+0x48>
    path++;
  if(*path == 0)
80101d22:	84 c0                	test   %al,%al
80101d24:	0f 84 e3 00 00 00    	je     80101e0d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d2a:	0f b6 03             	movzbl (%ebx),%eax
80101d2d:	89 da                	mov    %ebx,%edx
80101d2f:	84 c0                	test   %al,%al
80101d31:	0f 84 ac 00 00 00    	je     80101de3 <namex+0x113>
80101d37:	3c 2f                	cmp    $0x2f,%al
80101d39:	75 09                	jne    80101d44 <namex+0x74>
80101d3b:	e9 a3 00 00 00       	jmp    80101de3 <namex+0x113>
80101d40:	84 c0                	test   %al,%al
80101d42:	74 0a                	je     80101d4e <namex+0x7e>
    path++;
80101d44:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d47:	0f b6 02             	movzbl (%edx),%eax
80101d4a:	3c 2f                	cmp    $0x2f,%al
80101d4c:	75 f2                	jne    80101d40 <namex+0x70>
80101d4e:	89 d1                	mov    %edx,%ecx
80101d50:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d52:	83 f9 0d             	cmp    $0xd,%ecx
80101d55:	0f 8e 8d 00 00 00    	jle    80101de8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d5b:	83 ec 04             	sub    $0x4,%esp
80101d5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d61:	6a 0e                	push   $0xe
80101d63:	53                   	push   %ebx
80101d64:	57                   	push   %edi
80101d65:	e8 e6 27 00 00       	call   80104550 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101d6d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d70:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d72:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d75:	75 11                	jne    80101d88 <namex+0xb8>
80101d77:	89 f6                	mov    %esi,%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d83:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d86:	74 f8                	je     80101d80 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d88:	83 ec 0c             	sub    $0xc,%esp
80101d8b:	56                   	push   %esi
80101d8c:	e8 1f f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d91:	83 c4 10             	add    $0x10,%esp
80101d94:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d99:	0f 85 7f 00 00 00    	jne    80101e1e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101da2:	85 d2                	test   %edx,%edx
80101da4:	74 09                	je     80101daf <namex+0xdf>
80101da6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101da9:	0f 84 a3 00 00 00    	je     80101e52 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101daf:	83 ec 04             	sub    $0x4,%esp
80101db2:	6a 00                	push   $0x0
80101db4:	57                   	push   %edi
80101db5:	56                   	push   %esi
80101db6:	e8 65 fe ff ff       	call   80101c20 <dirlookup>
80101dbb:	83 c4 10             	add    $0x10,%esp
80101dbe:	85 c0                	test   %eax,%eax
80101dc0:	74 5c                	je     80101e1e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101dc8:	56                   	push   %esi
80101dc9:	e8 e2 f9 ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101dce:	89 34 24             	mov    %esi,(%esp)
80101dd1:	e8 2a fa ff ff       	call   80101800 <iput>
80101dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dd9:	83 c4 10             	add    $0x10,%esp
80101ddc:	89 c6                	mov    %eax,%esi
80101dde:	e9 38 ff ff ff       	jmp    80101d1b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101de3:	31 c9                	xor    %ecx,%ecx
80101de5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101de8:	83 ec 04             	sub    $0x4,%esp
80101deb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dee:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101df1:	51                   	push   %ecx
80101df2:	53                   	push   %ebx
80101df3:	57                   	push   %edi
80101df4:	e8 57 27 00 00       	call   80104550 <memmove>
    name[len] = 0;
80101df9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dff:	83 c4 10             	add    $0x10,%esp
80101e02:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e06:	89 d3                	mov    %edx,%ebx
80101e08:	e9 65 ff ff ff       	jmp    80101d72 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e10:	85 c0                	test   %eax,%eax
80101e12:	75 54                	jne    80101e68 <namex+0x198>
80101e14:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e19:	5b                   	pop    %ebx
80101e1a:	5e                   	pop    %esi
80101e1b:	5f                   	pop    %edi
80101e1c:	5d                   	pop    %ebp
80101e1d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e1e:	83 ec 0c             	sub    $0xc,%esp
80101e21:	56                   	push   %esi
80101e22:	e8 89 f9 ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101e27:	89 34 24             	mov    %esi,(%esp)
80101e2a:	e8 d1 f9 ff ff       	call   80101800 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e2f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e35:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e37:	5b                   	pop    %ebx
80101e38:	5e                   	pop    %esi
80101e39:	5f                   	pop    %edi
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e3c:	ba 01 00 00 00       	mov    $0x1,%edx
80101e41:	b8 01 00 00 00       	mov    $0x1,%eax
80101e46:	e8 c5 f3 ff ff       	call   80101210 <iget>
80101e4b:	89 c6                	mov    %eax,%esi
80101e4d:	e9 c9 fe ff ff       	jmp    80101d1b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e52:	83 ec 0c             	sub    $0xc,%esp
80101e55:	56                   	push   %esi
80101e56:	e8 55 f9 ff ff       	call   801017b0 <iunlock>
      return ip;
80101e5b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e61:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e63:	5b                   	pop    %ebx
80101e64:	5e                   	pop    %esi
80101e65:	5f                   	pop    %edi
80101e66:	5d                   	pop    %ebp
80101e67:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	56                   	push   %esi
80101e6c:	e8 8f f9 ff ff       	call   80101800 <iput>
    return 0;
80101e71:	83 c4 10             	add    $0x10,%esp
80101e74:	31 c0                	xor    %eax,%eax
80101e76:	eb 9e                	jmp    80101e16 <namex+0x146>
80101e78:	90                   	nop
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e80 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	83 ec 20             	sub    $0x20,%esp
80101e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e8c:	6a 00                	push   $0x0
80101e8e:	ff 75 0c             	pushl  0xc(%ebp)
80101e91:	53                   	push   %ebx
80101e92:	e8 89 fd ff ff       	call   80101c20 <dirlookup>
80101e97:	83 c4 10             	add    $0x10,%esp
80101e9a:	85 c0                	test   %eax,%eax
80101e9c:	75 67                	jne    80101f05 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e9e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ea1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ea4:	85 ff                	test   %edi,%edi
80101ea6:	74 29                	je     80101ed1 <dirlink+0x51>
80101ea8:	31 ff                	xor    %edi,%edi
80101eaa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ead:	eb 09                	jmp    80101eb8 <dirlink+0x38>
80101eaf:	90                   	nop
80101eb0:	83 c7 10             	add    $0x10,%edi
80101eb3:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101eb6:	76 19                	jbe    80101ed1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb8:	6a 10                	push   $0x10
80101eba:	57                   	push   %edi
80101ebb:	56                   	push   %esi
80101ebc:	53                   	push   %ebx
80101ebd:	e8 0e fb ff ff       	call   801019d0 <readi>
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	83 f8 10             	cmp    $0x10,%eax
80101ec8:	75 4e                	jne    80101f18 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101eca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ecf:	75 df                	jne    80101eb0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101ed1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ed4:	83 ec 04             	sub    $0x4,%esp
80101ed7:	6a 0e                	push   $0xe
80101ed9:	ff 75 0c             	pushl  0xc(%ebp)
80101edc:	50                   	push   %eax
80101edd:	e8 5e 27 00 00       	call   80104640 <strncpy>
  de.inum = inum;
80101ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee5:	6a 10                	push   $0x10
80101ee7:	57                   	push   %edi
80101ee8:	56                   	push   %esi
80101ee9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101eea:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eee:	e8 dd fb ff ff       	call   80101ad0 <writei>
80101ef3:	83 c4 20             	add    $0x20,%esp
80101ef6:	83 f8 10             	cmp    $0x10,%eax
80101ef9:	75 2a                	jne    80101f25 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101efb:	31 c0                	xor    %eax,%eax
}
80101efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	50                   	push   %eax
80101f09:	e8 f2 f8 ff ff       	call   80101800 <iput>
    return -1;
80101f0e:	83 c4 10             	add    $0x10,%esp
80101f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f16:	eb e5                	jmp    80101efd <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f18:	83 ec 0c             	sub    $0xc,%esp
80101f1b:	68 c8 70 10 80       	push   $0x801070c8
80101f20:	e8 4b e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f25:	83 ec 0c             	sub    $0xc,%esp
80101f28:	68 be 76 10 80       	push   $0x801076be
80101f2d:	e8 3e e4 ff ff       	call   80100370 <panic>
80101f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f40:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f41:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f43:	89 e5                	mov    %esp,%ebp
80101f45:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f4e:	e8 7d fd ff ff       	call   80101cd0 <namex>
}
80101f53:	c9                   	leave  
80101f54:	c3                   	ret    
80101f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f60 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f60:	55                   	push   %ebp
  return namex(path, 1, name);
80101f61:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f66:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f6e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f6f:	e9 5c fd ff ff       	jmp    80101cd0 <namex>
80101f74:	66 90                	xchg   %ax,%ax
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	66 90                	xchg   %ax,%ax
80101f7a:	66 90                	xchg   %ax,%ax
80101f7c:	66 90                	xchg   %ax,%ax
80101f7e:	66 90                	xchg   %ax,%ax

80101f80 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f80:	55                   	push   %ebp
  if(b == 0)
80101f81:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f83:	89 e5                	mov    %esp,%ebp
80101f85:	56                   	push   %esi
80101f86:	53                   	push   %ebx
  if(b == 0)
80101f87:	0f 84 ad 00 00 00    	je     8010203a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f8d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f90:	89 c1                	mov    %eax,%ecx
80101f92:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f98:	0f 87 8f 00 00 00    	ja     8010202d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f9e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fa3:	90                   	nop
80101fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fa9:	83 e0 c0             	and    $0xffffffc0,%eax
80101fac:	3c 40                	cmp    $0x40,%al
80101fae:	75 f8                	jne    80101fa8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fb0:	31 f6                	xor    %esi,%esi
80101fb2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fb7:	89 f0                	mov    %esi,%eax
80101fb9:	ee                   	out    %al,(%dx)
80101fba:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fbf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fc4:	ee                   	out    %al,(%dx)
80101fc5:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fca:	89 d8                	mov    %ebx,%eax
80101fcc:	ee                   	out    %al,(%dx)
80101fcd:	89 d8                	mov    %ebx,%eax
80101fcf:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fd4:	c1 f8 08             	sar    $0x8,%eax
80101fd7:	ee                   	out    %al,(%dx)
80101fd8:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fdd:	89 f0                	mov    %esi,%eax
80101fdf:	ee                   	out    %al,(%dx)
80101fe0:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101fe4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fe9:	83 e0 01             	and    $0x1,%eax
80101fec:	c1 e0 04             	shl    $0x4,%eax
80101fef:	83 c8 e0             	or     $0xffffffe0,%eax
80101ff2:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101ff3:	f6 01 04             	testb  $0x4,(%ecx)
80101ff6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ffb:	75 13                	jne    80102010 <idestart+0x90>
80101ffd:	b8 20 00 00 00       	mov    $0x20,%eax
80102002:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102003:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102006:	5b                   	pop    %ebx
80102007:	5e                   	pop    %esi
80102008:	5d                   	pop    %ebp
80102009:	c3                   	ret    
8010200a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102010:	b8 30 00 00 00       	mov    $0x30,%eax
80102015:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102016:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010201b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010201e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102023:	fc                   	cld    
80102024:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102026:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102029:	5b                   	pop    %ebx
8010202a:	5e                   	pop    %esi
8010202b:	5d                   	pop    %ebp
8010202c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 34 71 10 80       	push   $0x80107134
80102035:	e8 36 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010203a:	83 ec 0c             	sub    $0xc,%esp
8010203d:	68 2b 71 10 80       	push   $0x8010712b
80102042:	e8 29 e3 ff ff       	call   80100370 <panic>
80102047:	89 f6                	mov    %esi,%esi
80102049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102050 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102056:	68 46 71 10 80       	push   $0x80107146
8010205b:	68 80 a5 10 80       	push   $0x8010a580
80102060:	e8 db 21 00 00       	call   80104240 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102065:	58                   	pop    %eax
80102066:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010206b:	5a                   	pop    %edx
8010206c:	83 e8 01             	sub    $0x1,%eax
8010206f:	50                   	push   %eax
80102070:	6a 0e                	push   $0xe
80102072:	e8 a9 02 00 00       	call   80102320 <ioapicenable>
80102077:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010207a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010207f:	90                   	nop
80102080:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102081:	83 e0 c0             	and    $0xffffffc0,%eax
80102084:	3c 40                	cmp    $0x40,%al
80102086:	75 f8                	jne    80102080 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102088:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010208d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102092:	ee                   	out    %al,(%dx)
80102093:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102098:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010209d:	eb 06                	jmp    801020a5 <ideinit+0x55>
8010209f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801020a0:	83 e9 01             	sub    $0x1,%ecx
801020a3:	74 0f                	je     801020b4 <ideinit+0x64>
801020a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020a6:	84 c0                	test   %al,%al
801020a8:	74 f6                	je     801020a0 <ideinit+0x50>
      havedisk1 = 1;
801020aa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020b1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020b4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020b9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020be:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801020bf:	c9                   	leave  
801020c0:	c3                   	ret    
801020c1:	eb 0d                	jmp    801020d0 <ideintr>
801020c3:	90                   	nop
801020c4:	90                   	nop
801020c5:	90                   	nop
801020c6:	90                   	nop
801020c7:	90                   	nop
801020c8:	90                   	nop
801020c9:	90                   	nop
801020ca:	90                   	nop
801020cb:	90                   	nop
801020cc:	90                   	nop
801020cd:	90                   	nop
801020ce:	90                   	nop
801020cf:	90                   	nop

801020d0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	57                   	push   %edi
801020d4:	56                   	push   %esi
801020d5:	53                   	push   %ebx
801020d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020d9:	68 80 a5 10 80       	push   $0x8010a580
801020de:	e8 bd 22 00 00       	call   801043a0 <acquire>

  if((b = idequeue) == 0){
801020e3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020e9:	83 c4 10             	add    $0x10,%esp
801020ec:	85 db                	test   %ebx,%ebx
801020ee:	74 34                	je     80102124 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020f0:	8b 43 58             	mov    0x58(%ebx),%eax
801020f3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020f8:	8b 33                	mov    (%ebx),%esi
801020fa:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102100:	74 3e                	je     80102140 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102102:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102105:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102108:	83 ce 02             	or     $0x2,%esi
8010210b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010210d:	53                   	push   %ebx
8010210e:	e8 4d 1e 00 00       	call   80103f60 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102113:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102118:	83 c4 10             	add    $0x10,%esp
8010211b:	85 c0                	test   %eax,%eax
8010211d:	74 05                	je     80102124 <ideintr+0x54>
    idestart(idequeue);
8010211f:	e8 5c fe ff ff       	call   80101f80 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102124:	83 ec 0c             	sub    $0xc,%esp
80102127:	68 80 a5 10 80       	push   $0x8010a580
8010212c:	e8 1f 23 00 00       	call   80104450 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102131:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102134:	5b                   	pop    %ebx
80102135:	5e                   	pop    %esi
80102136:	5f                   	pop    %edi
80102137:	5d                   	pop    %ebp
80102138:	c3                   	ret    
80102139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102140:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102145:	8d 76 00             	lea    0x0(%esi),%esi
80102148:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102149:	89 c1                	mov    %eax,%ecx
8010214b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010214e:	80 f9 40             	cmp    $0x40,%cl
80102151:	75 f5                	jne    80102148 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102153:	a8 21                	test   $0x21,%al
80102155:	75 ab                	jne    80102102 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102157:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010215a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010215f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102164:	fc                   	cld    
80102165:	f3 6d                	rep insl (%dx),%es:(%edi)
80102167:	8b 33                	mov    (%ebx),%esi
80102169:	eb 97                	jmp    80102102 <ideintr+0x32>
8010216b:	90                   	nop
8010216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102170 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	53                   	push   %ebx
80102174:	83 ec 10             	sub    $0x10,%esp
80102177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010217a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010217d:	50                   	push   %eax
8010217e:	e8 6d 20 00 00       	call   801041f0 <holdingsleep>
80102183:	83 c4 10             	add    $0x10,%esp
80102186:	85 c0                	test   %eax,%eax
80102188:	0f 84 ad 00 00 00    	je     8010223b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 e0 06             	and    $0x6,%eax
80102193:	83 f8 02             	cmp    $0x2,%eax
80102196:	0f 84 b9 00 00 00    	je     80102255 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010219c:	8b 53 04             	mov    0x4(%ebx),%edx
8010219f:	85 d2                	test   %edx,%edx
801021a1:	74 0d                	je     801021b0 <iderw+0x40>
801021a3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021a8:	85 c0                	test   %eax,%eax
801021aa:	0f 84 98 00 00 00    	je     80102248 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021b0:	83 ec 0c             	sub    $0xc,%esp
801021b3:	68 80 a5 10 80       	push   $0x8010a580
801021b8:	e8 e3 21 00 00       	call   801043a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801021c3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021c6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cd:	85 d2                	test   %edx,%edx
801021cf:	75 09                	jne    801021da <iderw+0x6a>
801021d1:	eb 58                	jmp    8010222b <iderw+0xbb>
801021d3:	90                   	nop
801021d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021d8:	89 c2                	mov    %eax,%edx
801021da:	8b 42 58             	mov    0x58(%edx),%eax
801021dd:	85 c0                	test   %eax,%eax
801021df:	75 f7                	jne    801021d8 <iderw+0x68>
801021e1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021e4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021e6:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
801021ec:	74 44                	je     80102232 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ee:	8b 03                	mov    (%ebx),%eax
801021f0:	83 e0 06             	and    $0x6,%eax
801021f3:	83 f8 02             	cmp    $0x2,%eax
801021f6:	74 23                	je     8010221b <iderw+0xab>
801021f8:	90                   	nop
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102200:	83 ec 08             	sub    $0x8,%esp
80102203:	68 80 a5 10 80       	push   $0x8010a580
80102208:	53                   	push   %ebx
80102209:	e8 a2 1b 00 00       	call   80103db0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010220e:	8b 03                	mov    (%ebx),%eax
80102210:	83 c4 10             	add    $0x10,%esp
80102213:	83 e0 06             	and    $0x6,%eax
80102216:	83 f8 02             	cmp    $0x2,%eax
80102219:	75 e5                	jne    80102200 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010221b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102225:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102226:	e9 25 22 00 00       	jmp    80104450 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010222b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102230:	eb b2                	jmp    801021e4 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102232:	89 d8                	mov    %ebx,%eax
80102234:	e8 47 fd ff ff       	call   80101f80 <idestart>
80102239:	eb b3                	jmp    801021ee <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010223b:	83 ec 0c             	sub    $0xc,%esp
8010223e:	68 4a 71 10 80       	push   $0x8010714a
80102243:	e8 28 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102248:	83 ec 0c             	sub    $0xc,%esp
8010224b:	68 75 71 10 80       	push   $0x80107175
80102250:	e8 1b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102255:	83 ec 0c             	sub    $0xc,%esp
80102258:	68 60 71 10 80       	push   $0x80107160
8010225d:	e8 0e e1 ff ff       	call   80100370 <panic>
80102262:	66 90                	xchg   %ax,%ax
80102264:	66 90                	xchg   %ax,%ax
80102266:	66 90                	xchg   %ax,%ax
80102268:	66 90                	xchg   %ax,%ax
8010226a:	66 90                	xchg   %ax,%ax
8010226c:	66 90                	xchg   %ax,%ax
8010226e:	66 90                	xchg   %ax,%ax

80102270 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102270:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102271:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102278:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010227b:	89 e5                	mov    %esp,%ebp
8010227d:	56                   	push   %esi
8010227e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010227f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102286:	00 00 00 
  return ioapic->data;
80102289:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010228f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102292:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102298:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010229e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022a5:	89 f0                	mov    %esi,%eax
801022a7:	c1 e8 10             	shr    $0x10,%eax
801022aa:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801022ad:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022b0:	c1 e8 18             	shr    $0x18,%eax
801022b3:	39 d0                	cmp    %edx,%eax
801022b5:	74 16                	je     801022cd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022b7:	83 ec 0c             	sub    $0xc,%esp
801022ba:	68 94 71 10 80       	push   $0x80107194
801022bf:	e8 9c e3 ff ff       	call   80100660 <cprintf>
801022c4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022ca:	83 c4 10             	add    $0x10,%esp
801022cd:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022d0:	ba 10 00 00 00       	mov    $0x10,%edx
801022d5:	b8 20 00 00 00       	mov    $0x20,%eax
801022da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022e0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022e2:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022e8:	89 c3                	mov    %eax,%ebx
801022ea:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801022f0:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022f3:	89 59 10             	mov    %ebx,0x10(%ecx)
801022f6:	8d 5a 01             	lea    0x1(%edx),%ebx
801022f9:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022fc:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022fe:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102300:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102306:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010230d:	75 d1                	jne    801022e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010230f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102312:	5b                   	pop    %ebx
80102313:	5e                   	pop    %esi
80102314:	5d                   	pop    %ebp
80102315:	c3                   	ret    
80102316:	8d 76 00             	lea    0x0(%esi),%esi
80102319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102320 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102320:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102321:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102327:	89 e5                	mov    %esp,%ebp
80102329:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010232c:	8d 50 20             	lea    0x20(%eax),%edx
8010232f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102333:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102335:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010233b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010233e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102341:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102344:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102346:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010234b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010234e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102351:	5d                   	pop    %ebp
80102352:	c3                   	ret    
80102353:	66 90                	xchg   %ax,%ax
80102355:	66 90                	xchg   %ax,%ax
80102357:	66 90                	xchg   %ax,%ax
80102359:	66 90                	xchg   %ax,%ax
8010235b:	66 90                	xchg   %ax,%ax
8010235d:	66 90                	xchg   %ax,%ax
8010235f:	90                   	nop

80102360 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 04             	sub    $0x4,%esp
80102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010236a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102370:	75 70                	jne    801023e2 <kfree+0x82>
80102372:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102378:	72 68                	jb     801023e2 <kfree+0x82>
8010237a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102380:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102385:	77 5b                	ja     801023e2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102387:	83 ec 04             	sub    $0x4,%esp
8010238a:	68 00 10 00 00       	push   $0x1000
8010238f:	6a 01                	push   $0x1
80102391:	53                   	push   %ebx
80102392:	e8 09 21 00 00       	call   801044a0 <memset>

  if(kmem.use_lock)
80102397:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	85 d2                	test   %edx,%edx
801023a2:	75 2c                	jne    801023d0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023a4:	a1 78 26 11 80       	mov    0x80112678,%eax
801023a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023ab:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801023b0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801023b6:	85 c0                	test   %eax,%eax
801023b8:	75 06                	jne    801023c0 <kfree+0x60>
    release(&kmem.lock);
}
801023ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023bd:	c9                   	leave  
801023be:	c3                   	ret    
801023bf:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023c0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ca:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023cb:	e9 80 20 00 00       	jmp    80104450 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023d0:	83 ec 0c             	sub    $0xc,%esp
801023d3:	68 40 26 11 80       	push   $0x80112640
801023d8:	e8 c3 1f 00 00       	call   801043a0 <acquire>
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	eb c2                	jmp    801023a4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023e2:	83 ec 0c             	sub    $0xc,%esp
801023e5:	68 c6 71 10 80       	push   $0x801071c6
801023ea:	e8 81 df ff ff       	call   80100370 <panic>
801023ef:	90                   	nop

801023f0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102401:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102407:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010240d:	39 de                	cmp    %ebx,%esi
8010240f:	72 23                	jb     80102434 <freerange+0x44>
80102411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102418:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010241e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102421:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102427:	50                   	push   %eax
80102428:	e8 33 ff ff ff       	call   80102360 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	39 f3                	cmp    %esi,%ebx
80102432:	76 e4                	jbe    80102418 <freerange+0x28>
    kfree(p);
}
80102434:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102437:	5b                   	pop    %ebx
80102438:	5e                   	pop    %esi
80102439:	5d                   	pop    %ebp
8010243a:	c3                   	ret    
8010243b:	90                   	nop
8010243c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102440 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102448:	83 ec 08             	sub    $0x8,%esp
8010244b:	68 cc 71 10 80       	push   $0x801071cc
80102450:	68 40 26 11 80       	push   $0x80112640
80102455:	e8 e6 1d 00 00       	call   80104240 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010245a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102460:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102467:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010246a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102470:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102476:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247c:	39 de                	cmp    %ebx,%esi
8010247e:	72 1c                	jb     8010249c <kinit1+0x5c>
    kfree(p);
80102480:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102486:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102489:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010248f:	50                   	push   %eax
80102490:	e8 cb fe ff ff       	call   80102360 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102495:	83 c4 10             	add    $0x10,%esp
80102498:	39 de                	cmp    %ebx,%esi
8010249a:	73 e4                	jae    80102480 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010249c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010249f:	5b                   	pop    %ebx
801024a0:	5e                   	pop    %esi
801024a1:	5d                   	pop    %ebp
801024a2:	c3                   	ret    
801024a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024b0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	56                   	push   %esi
801024b4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801024b8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024cd:	39 de                	cmp    %ebx,%esi
801024cf:	72 23                	jb     801024f4 <kinit2+0x44>
801024d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024de:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024e7:	50                   	push   %eax
801024e8:	e8 73 fe ff ff       	call   80102360 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ed:	83 c4 10             	add    $0x10,%esp
801024f0:	39 de                	cmp    %ebx,%esi
801024f2:	73 e4                	jae    801024d8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024fb:	00 00 00 
}
801024fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102501:	5b                   	pop    %ebx
80102502:	5e                   	pop    %esi
80102503:	5d                   	pop    %ebp
80102504:	c3                   	ret    
80102505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102517:	a1 74 26 11 80       	mov    0x80112674,%eax
8010251c:	85 c0                	test   %eax,%eax
8010251e:	75 30                	jne    80102550 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102520:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102526:	85 db                	test   %ebx,%ebx
80102528:	74 1c                	je     80102546 <kalloc+0x36>
    kmem.freelist = r->next;
8010252a:	8b 13                	mov    (%ebx),%edx
8010252c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102532:	85 c0                	test   %eax,%eax
80102534:	74 10                	je     80102546 <kalloc+0x36>
    release(&kmem.lock);
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	68 40 26 11 80       	push   $0x80112640
8010253e:	e8 0d 1f 00 00       	call   80104450 <release>
80102543:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102546:	89 d8                	mov    %ebx,%eax
80102548:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010254b:	c9                   	leave  
8010254c:	c3                   	ret    
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 40 26 11 80       	push   $0x80112640
80102558:	e8 43 1e 00 00       	call   801043a0 <acquire>
  r = kmem.freelist;
8010255d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102563:	83 c4 10             	add    $0x10,%esp
80102566:	a1 74 26 11 80       	mov    0x80112674,%eax
8010256b:	85 db                	test   %ebx,%ebx
8010256d:	75 bb                	jne    8010252a <kalloc+0x1a>
8010256f:	eb c1                	jmp    80102532 <kalloc+0x22>
80102571:	66 90                	xchg   %ax,%ax
80102573:	66 90                	xchg   %ax,%ax
80102575:	66 90                	xchg   %ax,%ax
80102577:	66 90                	xchg   %ax,%ax
80102579:	66 90                	xchg   %ax,%ax
8010257b:	66 90                	xchg   %ax,%ax
8010257d:	66 90                	xchg   %ax,%ax
8010257f:	90                   	nop

80102580 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102580:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102581:	ba 64 00 00 00       	mov    $0x64,%edx
80102586:	89 e5                	mov    %esp,%ebp
80102588:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102589:	a8 01                	test   $0x1,%al
8010258b:	0f 84 af 00 00 00    	je     80102640 <kbdgetc+0xc0>
80102591:	ba 60 00 00 00       	mov    $0x60,%edx
80102596:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102597:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010259a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025a0:	74 7e                	je     80102620 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025a2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801025a4:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025aa:	79 24                	jns    801025d0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801025ac:	f6 c1 40             	test   $0x40,%cl
801025af:	75 05                	jne    801025b6 <kbdgetc+0x36>
801025b1:	89 c2                	mov    %eax,%edx
801025b3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b6:	0f b6 82 00 73 10 80 	movzbl -0x7fef8d00(%edx),%eax
801025bd:	83 c8 40             	or     $0x40,%eax
801025c0:	0f b6 c0             	movzbl %al,%eax
801025c3:	f7 d0                	not    %eax
801025c5:	21 c8                	and    %ecx,%eax
801025c7:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801025cc:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ce:	5d                   	pop    %ebp
801025cf:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025d0:	f6 c1 40             	test   $0x40,%cl
801025d3:	74 09                	je     801025de <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025d5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025d8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025db:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025de:	0f b6 82 00 73 10 80 	movzbl -0x7fef8d00(%edx),%eax
801025e5:	09 c1                	or     %eax,%ecx
801025e7:	0f b6 82 00 72 10 80 	movzbl -0x7fef8e00(%edx),%eax
801025ee:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025f0:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025f2:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025f8:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025fb:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025fe:	8b 04 85 e0 71 10 80 	mov    -0x7fef8e20(,%eax,4),%eax
80102605:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102609:	74 c3                	je     801025ce <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010260b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010260e:	83 fa 19             	cmp    $0x19,%edx
80102611:	77 1d                	ja     80102630 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102613:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102616:	5d                   	pop    %ebp
80102617:	c3                   	ret    
80102618:	90                   	nop
80102619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102620:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102622:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret    
8010262b:	90                   	nop
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102630:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102633:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102636:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102637:	83 f9 19             	cmp    $0x19,%ecx
8010263a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010263d:	c3                   	ret    
8010263e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102645:	5d                   	pop    %ebp
80102646:	c3                   	ret    
80102647:	89 f6                	mov    %esi,%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <kbdintr>:

void
kbdintr(void)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102656:	68 80 25 10 80       	push   $0x80102580
8010265b:	e8 90 e1 ff ff       	call   801007f0 <consoleintr>
}
80102660:	83 c4 10             	add    $0x10,%esp
80102663:	c9                   	leave  
80102664:	c3                   	ret    
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c8 00 00 00    	je     80102748 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 77                	ja     80102750 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102730:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102736:	80 e6 10             	and    $0x10,%dh
80102739:	75 f5                	jne    80102730 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010273b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102742:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102745:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102748:	5d                   	pop    %ebp
80102749:	c3                   	ret    
8010274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102750:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102757:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx
8010275d:	e9 77 ff ff ff       	jmp    801026d9 <lapicinit+0x69>
80102762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0c                	je     80102788 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010277c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010277f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102780:	c1 e8 18             	shr    $0x18,%eax
}
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102788:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027c0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	b8 0f 00 00 00       	mov    $0xf,%eax
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	ba 71 00 00 00       	mov    $0x71,%edx
801027da:	b8 0a 00 00 00       	mov    $0xa,%eax
801027df:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027e0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027eb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ed:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027f0:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fe:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102803:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102809:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102813:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102816:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102819:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102820:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102823:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102826:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102838:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102841:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010284a:	5b                   	pop    %ebx
8010284b:	5d                   	pop    %ebp
8010284c:	c3                   	ret    
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	ba 70 00 00 00       	mov    $0x70,%edx
80102856:	b8 0b 00 00 00       	mov    $0xb,%eax
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	ba 71 00 00 00       	mov    $0x71,%edx
80102869:	ec                   	in     (%dx),%al
8010286a:	83 e0 04             	and    $0x4,%eax
8010286d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102870:	31 db                	xor    %ebx,%ebx
80102872:	88 45 b7             	mov    %al,-0x49(%ebp)
80102875:	bf 70 00 00 00       	mov    $0x70,%edi
8010287a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102880:	89 d8                	mov    %ebx,%eax
80102882:	89 fa                	mov    %edi,%edx
80102884:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102885:	b9 71 00 00 00       	mov    $0x71,%ecx
8010288a:	89 ca                	mov    %ecx,%edx
8010288c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010288d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102890:	89 fa                	mov    %edi,%edx
80102892:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102895:	b8 02 00 00 00       	mov    $0x2,%eax
8010289a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289b:	89 ca                	mov    %ecx,%edx
8010289d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010289e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a1:	89 fa                	mov    %edi,%edx
801028a3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028a6:	b8 04 00 00 00       	mov    $0x4,%eax
801028ab:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028af:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b2:	89 fa                	mov    %edi,%edx
801028b4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028b7:	b8 07 00 00 00       	mov    $0x7,%eax
801028bc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bd:	89 ca                	mov    %ecx,%edx
801028bf:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028c0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c3:	89 fa                	mov    %edi,%edx
801028c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c8:	b8 08 00 00 00       	mov    $0x8,%eax
801028cd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ce:	89 ca                	mov    %ecx,%edx
801028d0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028d1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d4:	89 fa                	mov    %edi,%edx
801028d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028d9:	b8 09 00 00 00       	mov    $0x9,%eax
801028de:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028df:	89 ca                	mov    %ecx,%edx
801028e1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028e2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e5:	89 fa                	mov    %edi,%edx
801028e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028ea:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ef:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f0:	89 ca                	mov    %ecx,%edx
801028f2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028f3:	84 c0                	test   %al,%al
801028f5:	78 89                	js     80102880 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f7:	89 d8                	mov    %ebx,%eax
801028f9:	89 fa                	mov    %edi,%edx
801028fb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fc:	89 ca                	mov    %ecx,%edx
801028fe:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028ff:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102902:	89 fa                	mov    %edi,%edx
80102904:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102907:	b8 02 00 00 00       	mov    $0x2,%eax
8010290c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290d:	89 ca                	mov    %ecx,%edx
8010290f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102910:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102913:	89 fa                	mov    %edi,%edx
80102915:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102918:	b8 04 00 00 00       	mov    $0x4,%eax
8010291d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291e:	89 ca                	mov    %ecx,%edx
80102920:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102921:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102924:	89 fa                	mov    %edi,%edx
80102926:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102929:	b8 07 00 00 00       	mov    $0x7,%eax
8010292e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292f:	89 ca                	mov    %ecx,%edx
80102931:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102932:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102935:	89 fa                	mov    %edi,%edx
80102937:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010293a:	b8 08 00 00 00       	mov    $0x8,%eax
8010293f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102940:	89 ca                	mov    %ecx,%edx
80102942:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102943:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102946:	89 fa                	mov    %edi,%edx
80102948:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010294b:	b8 09 00 00 00       	mov    $0x9,%eax
80102950:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102951:	89 ca                	mov    %ecx,%edx
80102953:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102954:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102957:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010295a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010295d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102960:	6a 18                	push   $0x18
80102962:	56                   	push   %esi
80102963:	50                   	push   %eax
80102964:	e8 87 1b 00 00       	call   801044f0 <memcmp>
80102969:	83 c4 10             	add    $0x10,%esp
8010296c:	85 c0                	test   %eax,%eax
8010296e:	0f 85 0c ff ff ff    	jne    80102880 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102974:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102978:	75 78                	jne    801029f2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010297a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010297d:	89 c2                	mov    %eax,%edx
8010297f:	83 e0 0f             	and    $0xf,%eax
80102982:	c1 ea 04             	shr    $0x4,%edx
80102985:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102988:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010298e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102991:	89 c2                	mov    %eax,%edx
80102993:	83 e0 0f             	and    $0xf,%eax
80102996:	c1 ea 04             	shr    $0x4,%edx
80102999:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029a2:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a5:	89 c2                	mov    %eax,%edx
801029a7:	83 e0 0f             	and    $0xf,%eax
801029aa:	c1 ea 04             	shr    $0x4,%edx
801029ad:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029b6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029b9:	89 c2                	mov    %eax,%edx
801029bb:	83 e0 0f             	and    $0xf,%eax
801029be:	c1 ea 04             	shr    $0x4,%edx
801029c1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029cd:	89 c2                	mov    %eax,%edx
801029cf:	83 e0 0f             	and    $0xf,%eax
801029d2:	c1 ea 04             	shr    $0x4,%edx
801029d5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029db:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029de:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e1:	89 c2                	mov    %eax,%edx
801029e3:	83 e0 0f             	and    $0xf,%eax
801029e6:	c1 ea 04             	shr    $0x4,%edx
801029e9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ec:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029f2:	8b 75 08             	mov    0x8(%ebp),%esi
801029f5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029f8:	89 06                	mov    %eax,(%esi)
801029fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029fd:	89 46 04             	mov    %eax,0x4(%esi)
80102a00:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a03:	89 46 08             	mov    %eax,0x8(%esi)
80102a06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a09:	89 46 0c             	mov    %eax,0xc(%esi)
80102a0c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a0f:	89 46 10             	mov    %eax,0x10(%esi)
80102a12:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a15:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a18:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a22:	5b                   	pop    %ebx
80102a23:	5e                   	pop    %esi
80102a24:	5f                   	pop    %edi
80102a25:	5d                   	pop    %ebp
80102a26:	c3                   	ret    
80102a27:	66 90                	xchg   %ax,%ax
80102a29:	66 90                	xchg   %ax,%ax
80102a2b:	66 90                	xchg   %ax,%ax
80102a2d:	66 90                	xchg   %ax,%ax
80102a2f:	90                   	nop

80102a30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a30:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a36:	85 c9                	test   %ecx,%ecx
80102a38:	0f 8e 85 00 00 00    	jle    80102ac3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a3e:	55                   	push   %ebp
80102a3f:	89 e5                	mov    %esp,%ebp
80102a41:	57                   	push   %edi
80102a42:	56                   	push   %esi
80102a43:	53                   	push   %ebx
80102a44:	31 db                	xor    %ebx,%ebx
80102a46:	83 ec 0c             	sub    $0xc,%esp
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a50:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a55:	83 ec 08             	sub    $0x8,%esp
80102a58:	01 d8                	add    %ebx,%eax
80102a5a:	83 c0 01             	add    $0x1,%eax
80102a5d:	50                   	push   %eax
80102a5e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a64:	e8 67 d6 ff ff       	call   801000d0 <bread>
80102a69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6b:	58                   	pop    %eax
80102a6c:	5a                   	pop    %edx
80102a6d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a74:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7d:	e8 4e d6 ff ff       	call   801000d0 <bread>
80102a82:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a84:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a87:	83 c4 0c             	add    $0xc,%esp
80102a8a:	68 00 02 00 00       	push   $0x200
80102a8f:	50                   	push   %eax
80102a90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a93:	50                   	push   %eax
80102a94:	e8 b7 1a 00 00       	call   80104550 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 ff d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102aa1:	89 3c 24             	mov    %edi,(%esp)
80102aa4:	e8 37 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 2f d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ab1:	83 c4 10             	add    $0x10,%esp
80102ab4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102aba:	7f 94                	jg     80102a50 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102abf:	5b                   	pop    %ebx
80102ac0:	5e                   	pop    %esi
80102ac1:	5f                   	pop    %edi
80102ac2:	5d                   	pop    %ebp
80102ac3:	f3 c3                	repz ret 
80102ac5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	53                   	push   %ebx
80102ad4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ad7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102add:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ae3:	e8 e8 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ae8:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102aee:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102af1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102af3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102af5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102af8:	7e 1f                	jle    80102b19 <write_head+0x49>
80102afa:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102b01:	31 d2                	xor    %edx,%edx
80102b03:	90                   	nop
80102b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102b08:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102b0e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102b12:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b15:	39 c2                	cmp    %eax,%edx
80102b17:	75 ef                	jne    80102b08 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102b19:	83 ec 0c             	sub    $0xc,%esp
80102b1c:	53                   	push   %ebx
80102b1d:	e8 7e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b22:	89 1c 24             	mov    %ebx,(%esp)
80102b25:	e8 b6 d6 ff ff       	call   801001e0 <brelse>
}
80102b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b2d:	c9                   	leave  
80102b2e:	c3                   	ret    
80102b2f:	90                   	nop

80102b30 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	53                   	push   %ebx
80102b34:	83 ec 2c             	sub    $0x2c,%esp
80102b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b3a:	68 00 74 10 80       	push   $0x80107400
80102b3f:	68 80 26 11 80       	push   $0x80112680
80102b44:	e8 f7 16 00 00       	call   80104240 <initlock>
  readsb(dev, &sb);
80102b49:	58                   	pop    %eax
80102b4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 5b e8 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b55:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b58:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b5b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b5c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b62:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b68:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b6d:	5a                   	pop    %edx
80102b6e:	50                   	push   %eax
80102b6f:	53                   	push   %ebx
80102b70:	e8 5b d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b75:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b78:	83 c4 10             	add    $0x10,%esp
80102b7b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b7d:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b83:	7e 1c                	jle    80102ba1 <initlog+0x71>
80102b85:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b8c:	31 d2                	xor    %edx,%edx
80102b8e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b90:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b94:	83 c2 04             	add    $0x4,%edx
80102b97:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b9d:	39 da                	cmp    %ebx,%edx
80102b9f:	75 ef                	jne    80102b90 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ba1:	83 ec 0c             	sub    $0xc,%esp
80102ba4:	50                   	push   %eax
80102ba5:	e8 36 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102baa:	e8 81 fe ff ff       	call   80102a30 <install_trans>
  log.lh.n = 0;
80102baf:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102bb6:	00 00 00 
  write_head(); // clear the log
80102bb9:	e8 12 ff ff ff       	call   80102ad0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc1:	c9                   	leave  
80102bc2:	c3                   	ret    
80102bc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bd6:	68 80 26 11 80       	push   $0x80112680
80102bdb:	e8 c0 17 00 00       	call   801043a0 <acquire>
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	eb 18                	jmp    80102bfd <begin_op+0x2d>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	83 ec 08             	sub    $0x8,%esp
80102beb:	68 80 26 11 80       	push   $0x80112680
80102bf0:	68 80 26 11 80       	push   $0x80112680
80102bf5:	e8 b6 11 00 00       	call   80103db0 <sleep>
80102bfa:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bfd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 e2                	jne    80102be8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c06:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c0b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c11:	83 c0 01             	add    $0x1,%eax
80102c14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c1a:	83 fa 1e             	cmp    $0x1e,%edx
80102c1d:	7f c9                	jg     80102be8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c1f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c22:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c27:	68 80 26 11 80       	push   $0x80112680
80102c2c:	e8 1f 18 00 00       	call   80104450 <release>
      break;
    }
  }
}
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	57                   	push   %edi
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c49:	68 80 26 11 80       	push   $0x80112680
80102c4e:	e8 4d 17 00 00       	call   801043a0 <acquire>
  log.outstanding -= 1;
80102c53:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c58:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102c5e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c61:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c64:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c66:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102c6b:	0f 85 23 01 00 00    	jne    80102d94 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c71:	85 c0                	test   %eax,%eax
80102c73:	0f 85 f7 00 00 00    	jne    80102d70 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c79:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c7c:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c83:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c86:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c88:	68 80 26 11 80       	push   $0x80112680
80102c8d:	e8 be 17 00 00       	call   80104450 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c92:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c98:	83 c4 10             	add    $0x10,%esp
80102c9b:	85 c9                	test   %ecx,%ecx
80102c9d:	0f 8e 8a 00 00 00    	jle    80102d2d <end_op+0xed>
80102ca3:	90                   	nop
80102ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102cad:	83 ec 08             	sub    $0x8,%esp
80102cb0:	01 d8                	add    %ebx,%eax
80102cb2:	83 c0 01             	add    $0x1,%eax
80102cb5:	50                   	push   %eax
80102cb6:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102cbc:	e8 0f d4 ff ff       	call   801000d0 <bread>
80102cc1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cc3:	58                   	pop    %eax
80102cc4:	5a                   	pop    %edx
80102cc5:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ccc:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cd2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cd5:	e8 f6 d3 ff ff       	call   801000d0 <bread>
80102cda:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cdc:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cdf:	83 c4 0c             	add    $0xc,%esp
80102ce2:	68 00 02 00 00       	push   $0x200
80102ce7:	50                   	push   %eax
80102ce8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ceb:	50                   	push   %eax
80102cec:	e8 5f 18 00 00       	call   80104550 <memmove>
    bwrite(to);  // write the log
80102cf1:	89 34 24             	mov    %esi,(%esp)
80102cf4:	e8 a7 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cf9:	89 3c 24             	mov    %edi,(%esp)
80102cfc:	e8 df d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d01:	89 34 24             	mov    %esi,(%esp)
80102d04:	e8 d7 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d09:	83 c4 10             	add    $0x10,%esp
80102d0c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d12:	7c 94                	jl     80102ca8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d14:	e8 b7 fd ff ff       	call   80102ad0 <write_head>
    install_trans(); // Now install writes to home locations
80102d19:	e8 12 fd ff ff       	call   80102a30 <install_trans>
    log.lh.n = 0;
80102d1e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d25:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d28:	e8 a3 fd ff ff       	call   80102ad0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d2d:	83 ec 0c             	sub    $0xc,%esp
80102d30:	68 80 26 11 80       	push   $0x80112680
80102d35:	e8 66 16 00 00       	call   801043a0 <acquire>
    log.committing = 0;
    wakeup(&log);
80102d3a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102d41:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d48:	00 00 00 
    wakeup(&log);
80102d4b:	e8 10 12 00 00       	call   80103f60 <wakeup>
    release(&log.lock);
80102d50:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d57:	e8 f4 16 00 00       	call   80104450 <release>
80102d5c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d62:	5b                   	pop    %ebx
80102d63:	5e                   	pop    %esi
80102d64:	5f                   	pop    %edi
80102d65:	5d                   	pop    %ebp
80102d66:	c3                   	ret    
80102d67:	89 f6                	mov    %esi,%esi
80102d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102d70:	83 ec 0c             	sub    $0xc,%esp
80102d73:	68 80 26 11 80       	push   $0x80112680
80102d78:	e8 e3 11 00 00       	call   80103f60 <wakeup>
  }
  release(&log.lock);
80102d7d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d84:	e8 c7 16 00 00       	call   80104450 <release>
80102d89:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d8f:	5b                   	pop    %ebx
80102d90:	5e                   	pop    %esi
80102d91:	5f                   	pop    %edi
80102d92:	5d                   	pop    %ebp
80102d93:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d94:	83 ec 0c             	sub    $0xc,%esp
80102d97:	68 04 74 10 80       	push   $0x80107404
80102d9c:	e8 cf d5 ff ff       	call   80100370 <panic>
80102da1:	eb 0d                	jmp    80102db0 <log_write>
80102da3:	90                   	nop
80102da4:	90                   	nop
80102da5:	90                   	nop
80102da6:	90                   	nop
80102da7:	90                   	nop
80102da8:	90                   	nop
80102da9:	90                   	nop
80102daa:	90                   	nop
80102dab:	90                   	nop
80102dac:	90                   	nop
80102dad:	90                   	nop
80102dae:	90                   	nop
80102daf:	90                   	nop

80102db0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dc0:	83 fa 1d             	cmp    $0x1d,%edx
80102dc3:	0f 8f 97 00 00 00    	jg     80102e60 <log_write+0xb0>
80102dc9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102dce:	83 e8 01             	sub    $0x1,%eax
80102dd1:	39 c2                	cmp    %eax,%edx
80102dd3:	0f 8d 87 00 00 00    	jge    80102e60 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dd9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	0f 8e 87 00 00 00    	jle    80102e6d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	68 80 26 11 80       	push   $0x80112680
80102dee:	e8 ad 15 00 00       	call   801043a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102df3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	83 fa 00             	cmp    $0x0,%edx
80102dff:	7e 50                	jle    80102e51 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e01:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e04:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e06:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102e0c:	75 0b                	jne    80102e19 <log_write+0x69>
80102e0e:	eb 38                	jmp    80102e48 <log_write+0x98>
80102e10:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102e17:	74 2f                	je     80102e48 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e19:	83 c0 01             	add    $0x1,%eax
80102e1c:	39 d0                	cmp    %edx,%eax
80102e1e:	75 f0                	jne    80102e10 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e20:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e27:	83 c2 01             	add    $0x1,%edx
80102e2a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e30:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e33:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e3e:	e9 0d 16 00 00       	jmp    80104450 <release>
80102e43:	90                   	nop
80102e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e48:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102e4f:	eb df                	jmp    80102e30 <log_write+0x80>
80102e51:	8b 43 08             	mov    0x8(%ebx),%eax
80102e54:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e59:	75 d5                	jne    80102e30 <log_write+0x80>
80102e5b:	eb ca                	jmp    80102e27 <log_write+0x77>
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e60:	83 ec 0c             	sub    $0xc,%esp
80102e63:	68 13 74 10 80       	push   $0x80107413
80102e68:	e8 03 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e6d:	83 ec 0c             	sub    $0xc,%esp
80102e70:	68 29 74 10 80       	push   $0x80107429
80102e75:	e8 f6 d4 ff ff       	call   80100370 <panic>
80102e7a:	66 90                	xchg   %ax,%ax
80102e7c:	66 90                	xchg   %ax,%ax
80102e7e:	66 90                	xchg   %ax,%ax

80102e80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e87:	e8 54 09 00 00       	call   801037e0 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 4d 09 00 00       	call   801037e0 <cpuid>
80102e93:	83 ec 04             	sub    $0x4,%esp
80102e96:	53                   	push   %ebx
80102e97:	50                   	push   %eax
80102e98:	68 44 74 10 80       	push   $0x80107444
80102e9d:	e8 be d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea2:	e8 b9 28 00 00       	call   80105760 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ea7:	e8 b4 08 00 00       	call   80103760 <mycpu>
80102eac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eae:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eba:	e8 01 0c 00 00       	call   80103ac0 <scheduler>
80102ebf:	90                   	nop

80102ec0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ec6:	e8 b5 39 00 00       	call   80106880 <switchkvm>
  seginit();
80102ecb:	e8 b0 38 00 00       	call   80106780 <seginit>
  lapicinit();
80102ed0:	e8 9b f7 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102ed5:	e8 a6 ff ff ff       	call   80102e80 <mpmain>
80102eda:	66 90                	xchg   %ax,%ax
80102edc:	66 90                	xchg   %ax,%ax
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ee0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ee4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ee7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eea:	55                   	push   %ebp
80102eeb:	89 e5                	mov    %esp,%ebp
80102eed:	53                   	push   %ebx
80102eee:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eef:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ef4:	83 ec 08             	sub    $0x8,%esp
80102ef7:	68 00 00 40 80       	push   $0x80400000
80102efc:	68 a8 54 11 80       	push   $0x801154a8
80102f01:	e8 3a f5 ff ff       	call   80102440 <kinit1>
  kvmalloc();      // kernel page table
80102f06:	e8 15 3e 00 00       	call   80106d20 <kvmalloc>
  mpinit();        // detect other processors
80102f0b:	e8 70 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f10:	e8 5b f7 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102f15:	e8 66 38 00 00       	call   80106780 <seginit>
  picinit();       // disable pic
80102f1a:	e8 31 03 00 00       	call   80103250 <picinit>
  ioapicinit();    // another interrupt controller
80102f1f:	e8 4c f3 ff ff       	call   80102270 <ioapicinit>
  consoleinit();   // console hardware
80102f24:	e8 77 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102f29:	e8 22 2b 00 00       	call   80105a50 <uartinit>
  pinit();         // process table
80102f2e:	e8 0d 08 00 00       	call   80103740 <pinit>
  tvinit();        // trap vectors
80102f33:	e8 88 27 00 00       	call   801056c0 <tvinit>
  binit();         // buffer cache
80102f38:	e8 03 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f3d:	e8 0e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102f42:	e8 09 f1 ff ff       	call   80102050 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f47:	83 c4 0c             	add    $0xc,%esp
80102f4a:	68 8a 00 00 00       	push   $0x8a
80102f4f:	68 8c a4 10 80       	push   $0x8010a48c
80102f54:	68 00 70 00 80       	push   $0x80007000
80102f59:	e8 f2 15 00 00       	call   80104550 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f5e:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f65:	00 00 00 
80102f68:	83 c4 10             	add    $0x10,%esp
80102f6b:	05 80 27 11 80       	add    $0x80112780,%eax
80102f70:	39 d8                	cmp    %ebx,%eax
80102f72:	76 6f                	jbe    80102fe3 <main+0x103>
80102f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f78:	e8 e3 07 00 00       	call   80103760 <mycpu>
80102f7d:	39 d8                	cmp    %ebx,%eax
80102f7f:	74 49                	je     80102fca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f81:	e8 8a f5 ff ff       	call   80102510 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f86:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f8b:	c7 05 f8 6f 00 80 c0 	movl   $0x80102ec0,0x80006ff8
80102f92:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f95:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f9c:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f9f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102fa4:	0f b6 03             	movzbl (%ebx),%eax
80102fa7:	83 ec 08             	sub    $0x8,%esp
80102faa:	68 00 70 00 00       	push   $0x7000
80102faf:	50                   	push   %eax
80102fb0:	e8 0b f8 ff ff       	call   801027c0 <lapicstartap>
80102fb5:	83 c4 10             	add    $0x10,%esp
80102fb8:	90                   	nop
80102fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fc0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	74 f6                	je     80102fc0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102fca:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fda:	05 80 27 11 80       	add    $0x80112780,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 95                	jb     80102f78 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 bb f4 ff ff       	call   801024b0 <kinit2>
  userinit();      // first user process
80102ff5:	e8 36 08 00 00       	call   80103830 <userinit>
  mpmain();        // finish this processor's setup
80102ffa:	e8 81 fe ff ff       	call   80102e80 <mpmain>
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103005:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010300b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010300c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010300f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103012:	39 de                	cmp    %ebx,%esi
80103014:	73 48                	jae    8010305e <mpsearch1+0x5e>
80103016:	8d 76 00             	lea    0x0(%esi),%esi
80103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103020:	83 ec 04             	sub    $0x4,%esp
80103023:	8d 7e 10             	lea    0x10(%esi),%edi
80103026:	6a 04                	push   $0x4
80103028:	68 58 74 10 80       	push   $0x80107458
8010302d:	56                   	push   %esi
8010302e:	e8 bd 14 00 00       	call   801044f0 <memcmp>
80103033:	83 c4 10             	add    $0x10,%esp
80103036:	85 c0                	test   %eax,%eax
80103038:	75 1e                	jne    80103058 <mpsearch1+0x58>
8010303a:	8d 7e 10             	lea    0x10(%esi),%edi
8010303d:	89 f2                	mov    %esi,%edx
8010303f:	31 c9                	xor    %ecx,%ecx
80103041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103048:	0f b6 02             	movzbl (%edx),%eax
8010304b:	83 c2 01             	add    $0x1,%edx
8010304e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103050:	39 fa                	cmp    %edi,%edx
80103052:	75 f4                	jne    80103048 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103054:	84 c9                	test   %cl,%cl
80103056:	74 10                	je     80103068 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103058:	39 fb                	cmp    %edi,%ebx
8010305a:	89 fe                	mov    %edi,%esi
8010305c:	77 c2                	ja     80103020 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010305e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103061:	31 c0                	xor    %eax,%eax
}
80103063:	5b                   	pop    %ebx
80103064:	5e                   	pop    %esi
80103065:	5f                   	pop    %edi
80103066:	5d                   	pop    %ebp
80103067:	c3                   	ret    
80103068:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010306b:	89 f0                	mov    %esi,%eax
8010306d:	5b                   	pop    %ebx
8010306e:	5e                   	pop    %esi
8010306f:	5f                   	pop    %edi
80103070:	5d                   	pop    %ebp
80103071:	c3                   	ret    
80103072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103080 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103089:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103090:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103097:	c1 e0 08             	shl    $0x8,%eax
8010309a:	09 d0                	or     %edx,%eax
8010309c:	c1 e0 04             	shl    $0x4,%eax
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 1b                	jne    801030be <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801030a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030b1:	c1 e0 08             	shl    $0x8,%eax
801030b4:	09 d0                	or     %edx,%eax
801030b6:	c1 e0 0a             	shl    $0xa,%eax
801030b9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801030be:	ba 00 04 00 00       	mov    $0x400,%edx
801030c3:	e8 38 ff ff ff       	call   80103000 <mpsearch1>
801030c8:	85 c0                	test   %eax,%eax
801030ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030cd:	0f 84 37 01 00 00    	je     8010320a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d6:	8b 58 04             	mov    0x4(%eax),%ebx
801030d9:	85 db                	test   %ebx,%ebx
801030db:	0f 84 43 01 00 00    	je     80103224 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030e7:	83 ec 04             	sub    $0x4,%esp
801030ea:	6a 04                	push   $0x4
801030ec:	68 5d 74 10 80       	push   $0x8010745d
801030f1:	56                   	push   %esi
801030f2:	e8 f9 13 00 00       	call   801044f0 <memcmp>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	85 c0                	test   %eax,%eax
801030fc:	0f 85 22 01 00 00    	jne    80103224 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103102:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103109:	3c 01                	cmp    $0x1,%al
8010310b:	74 08                	je     80103115 <mpinit+0x95>
8010310d:	3c 04                	cmp    $0x4,%al
8010310f:	0f 85 0f 01 00 00    	jne    80103224 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103115:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010311c:	85 ff                	test   %edi,%edi
8010311e:	74 21                	je     80103141 <mpinit+0xc1>
80103120:	31 d2                	xor    %edx,%edx
80103122:	31 c0                	xor    %eax,%eax
80103124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103128:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010312f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103130:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103133:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103135:	39 c7                	cmp    %eax,%edi
80103137:	75 ef                	jne    80103128 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103139:	84 d2                	test   %dl,%dl
8010313b:	0f 85 e3 00 00 00    	jne    80103224 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103141:	85 f6                	test   %esi,%esi
80103143:	0f 84 db 00 00 00    	je     80103224 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103149:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010314f:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103154:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010315b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103161:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103166:	01 d6                	add    %edx,%esi
80103168:	90                   	nop
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	39 c6                	cmp    %eax,%esi
80103172:	76 23                	jbe    80103197 <mpinit+0x117>
80103174:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103177:	80 fa 04             	cmp    $0x4,%dl
8010317a:	0f 87 c0 00 00 00    	ja     80103240 <mpinit+0x1c0>
80103180:	ff 24 95 9c 74 10 80 	jmp    *-0x7fef8b64(,%edx,4)
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103190:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103193:	39 c6                	cmp    %eax,%esi
80103195:	77 dd                	ja     80103174 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103197:	85 db                	test   %ebx,%ebx
80103199:	0f 84 92 00 00 00    	je     80103231 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031a6:	74 15                	je     801031bd <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a8:	ba 22 00 00 00       	mov    $0x22,%edx
801031ad:	b8 70 00 00 00       	mov    $0x70,%eax
801031b2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b3:	ba 23 00 00 00       	mov    $0x23,%edx
801031b8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b9:	83 c8 01             	or     $0x1,%eax
801031bc:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801031c8:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801031ec:	83 c0 14             	add    $0x14,%eax
      continue;
801031ef:	e9 7c ff ff ff       	jmp    80103170 <mpinit+0xf0>
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031fc:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031ff:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103205:	e9 66 ff ff ff       	jmp    80103170 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010320a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010320f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103214:	e8 e7 fd ff ff       	call   80103000 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103219:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010321b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321e:	0f 85 af fe ff ff    	jne    801030d3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103224:	83 ec 0c             	sub    $0xc,%esp
80103227:	68 62 74 10 80       	push   $0x80107462
8010322c:	e8 3f d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103231:	83 ec 0c             	sub    $0xc,%esp
80103234:	68 7c 74 10 80       	push   $0x8010747c
80103239:	e8 32 d1 ff ff       	call   80100370 <panic>
8010323e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103240:	31 db                	xor    %ebx,%ebx
80103242:	e9 30 ff ff ff       	jmp    80103177 <mpinit+0xf7>
80103247:	66 90                	xchg   %ax,%ax
80103249:	66 90                	xchg   %ax,%ax
8010324b:	66 90                	xchg   %ax,%ax
8010324d:	66 90                	xchg   %ax,%ax
8010324f:	90                   	nop

80103250 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103250:	55                   	push   %ebp
80103251:	ba 21 00 00 00       	mov    $0x21,%edx
80103256:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	ee                   	out    %al,(%dx)
8010325e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103263:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103264:	5d                   	pop    %ebp
80103265:	c3                   	ret    
80103266:	66 90                	xchg   %ax,%ax
80103268:	66 90                	xchg   %ax,%ax
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	8b 75 08             	mov    0x8(%ebp),%esi
8010327c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010327f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103285:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010328b:	e8 e0 da ff ff       	call   80100d70 <filealloc>
80103290:	85 c0                	test   %eax,%eax
80103292:	89 06                	mov    %eax,(%esi)
80103294:	0f 84 a8 00 00 00    	je     80103342 <pipealloc+0xd2>
8010329a:	e8 d1 da ff ff       	call   80100d70 <filealloc>
8010329f:	85 c0                	test   %eax,%eax
801032a1:	89 03                	mov    %eax,(%ebx)
801032a3:	0f 84 87 00 00 00    	je     80103330 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032a9:	e8 62 f2 ff ff       	call   80102510 <kalloc>
801032ae:	85 c0                	test   %eax,%eax
801032b0:	89 c7                	mov    %eax,%edi
801032b2:	0f 84 b0 00 00 00    	je     80103368 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801032b8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801032bb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032c2:	00 00 00 
  p->writeopen = 1;
801032c5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032cc:	00 00 00 
  p->nwrite = 0;
801032cf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032d6:	00 00 00 
  p->nread = 0;
801032d9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032e0:	00 00 00 
  initlock(&p->lock, "pipe");
801032e3:	68 b0 74 10 80       	push   $0x801074b0
801032e8:	50                   	push   %eax
801032e9:	e8 52 0f 00 00       	call   80104240 <initlock>
  (*f0)->type = FD_PIPE;
801032ee:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801032f0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801032f3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801032f9:	8b 06                	mov    (%esi),%eax
801032fb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801032ff:	8b 06                	mov    (%esi),%eax
80103301:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103305:	8b 06                	mov    (%esi),%eax
80103307:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010330a:	8b 03                	mov    (%ebx),%eax
8010330c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103312:	8b 03                	mov    (%ebx),%eax
80103314:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103318:	8b 03                	mov    (%ebx),%eax
8010331a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010331e:	8b 03                	mov    (%ebx),%eax
80103320:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103326:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103328:	5b                   	pop    %ebx
80103329:	5e                   	pop    %esi
8010332a:	5f                   	pop    %edi
8010332b:	5d                   	pop    %ebp
8010332c:	c3                   	ret    
8010332d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103330:	8b 06                	mov    (%esi),%eax
80103332:	85 c0                	test   %eax,%eax
80103334:	74 1e                	je     80103354 <pipealloc+0xe4>
    fileclose(*f0);
80103336:	83 ec 0c             	sub    $0xc,%esp
80103339:	50                   	push   %eax
8010333a:	e8 f1 da ff ff       	call   80100e30 <fileclose>
8010333f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103342:	8b 03                	mov    (%ebx),%eax
80103344:	85 c0                	test   %eax,%eax
80103346:	74 0c                	je     80103354 <pipealloc+0xe4>
    fileclose(*f1);
80103348:	83 ec 0c             	sub    $0xc,%esp
8010334b:	50                   	push   %eax
8010334c:	e8 df da ff ff       	call   80100e30 <fileclose>
80103351:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103354:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010335c:	5b                   	pop    %ebx
8010335d:	5e                   	pop    %esi
8010335e:	5f                   	pop    %edi
8010335f:	5d                   	pop    %ebp
80103360:	c3                   	ret    
80103361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103368:	8b 06                	mov    (%esi),%eax
8010336a:	85 c0                	test   %eax,%eax
8010336c:	75 c8                	jne    80103336 <pipealloc+0xc6>
8010336e:	eb d2                	jmp    80103342 <pipealloc+0xd2>

80103370 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	56                   	push   %esi
80103374:	53                   	push   %ebx
80103375:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103378:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010337b:	83 ec 0c             	sub    $0xc,%esp
8010337e:	53                   	push   %ebx
8010337f:	e8 1c 10 00 00       	call   801043a0 <acquire>
  if(writable){
80103384:	83 c4 10             	add    $0x10,%esp
80103387:	85 f6                	test   %esi,%esi
80103389:	74 45                	je     801033d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010338b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103391:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103394:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010339b:	00 00 00 
    wakeup(&p->nread);
8010339e:	50                   	push   %eax
8010339f:	e8 bc 0b 00 00       	call   80103f60 <wakeup>
801033a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033ad:	85 d2                	test   %edx,%edx
801033af:	75 0a                	jne    801033bb <pipeclose+0x4b>
801033b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033b7:	85 c0                	test   %eax,%eax
801033b9:	74 35                	je     801033f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033c1:	5b                   	pop    %ebx
801033c2:	5e                   	pop    %esi
801033c3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033c4:	e9 87 10 00 00       	jmp    80104450 <release>
801033c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801033d0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033d6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801033d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033e0:	00 00 00 
    wakeup(&p->nwrite);
801033e3:	50                   	push   %eax
801033e4:	e8 77 0b 00 00       	call   80103f60 <wakeup>
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	eb b9                	jmp    801033a7 <pipeclose+0x37>
801033ee:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	53                   	push   %ebx
801033f4:	e8 57 10 00 00       	call   80104450 <release>
    kfree((char*)p);
801033f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033fc:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801033ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103402:	5b                   	pop    %ebx
80103403:	5e                   	pop    %esi
80103404:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103405:	e9 56 ef ff ff       	jmp    80102360 <kfree>
8010340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103410 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 28             	sub    $0x28,%esp
80103419:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010341c:	53                   	push   %ebx
8010341d:	e8 7e 0f 00 00       	call   801043a0 <acquire>
  for(i = 0; i < n; i++){
80103422:	8b 45 10             	mov    0x10(%ebp),%eax
80103425:	83 c4 10             	add    $0x10,%esp
80103428:	85 c0                	test   %eax,%eax
8010342a:	0f 8e b9 00 00 00    	jle    801034e9 <pipewrite+0xd9>
80103430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103433:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103439:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010343f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103445:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103448:	03 4d 10             	add    0x10(%ebp),%ecx
8010344b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010344e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103454:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010345a:	39 d0                	cmp    %edx,%eax
8010345c:	74 38                	je     80103496 <pipewrite+0x86>
8010345e:	eb 59                	jmp    801034b9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103460:	e8 9b 03 00 00       	call   80103800 <myproc>
80103465:	8b 48 24             	mov    0x24(%eax),%ecx
80103468:	85 c9                	test   %ecx,%ecx
8010346a:	75 34                	jne    801034a0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010346c:	83 ec 0c             	sub    $0xc,%esp
8010346f:	57                   	push   %edi
80103470:	e8 eb 0a 00 00       	call   80103f60 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103475:	58                   	pop    %eax
80103476:	5a                   	pop    %edx
80103477:	53                   	push   %ebx
80103478:	56                   	push   %esi
80103479:	e8 32 09 00 00       	call   80103db0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010347e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103484:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010348a:	83 c4 10             	add    $0x10,%esp
8010348d:	05 00 02 00 00       	add    $0x200,%eax
80103492:	39 c2                	cmp    %eax,%edx
80103494:	75 2a                	jne    801034c0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103496:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	75 c0                	jne    80103460 <pipewrite+0x50>
        release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 a7 0f 00 00       	call   80104450 <release>
        return -1;
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b4:	5b                   	pop    %ebx
801034b5:	5e                   	pop    %esi
801034b6:	5f                   	pop    %edi
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034b9:	89 c2                	mov    %eax,%edx
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034c3:	8d 42 01             	lea    0x1(%edx),%eax
801034c6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801034ca:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034d0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034d6:	0f b6 09             	movzbl (%ecx),%ecx
801034d9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801034dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801034e0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801034e3:	0f 85 65 ff ff ff    	jne    8010344e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	50                   	push   %eax
801034f3:	e8 68 0a 00 00       	call   80103f60 <wakeup>
  release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 50 0f 00 00       	call   80104450 <release>
  return n;
80103500:	83 c4 10             	add    $0x10,%esp
80103503:	8b 45 10             	mov    0x10(%ebp),%eax
80103506:	eb a9                	jmp    801034b1 <pipewrite+0xa1>
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103510 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 18             	sub    $0x18,%esp
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010351f:	53                   	push   %ebx
80103520:	e8 7b 0e 00 00       	call   801043a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010352e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103534:	75 6a                	jne    801035a0 <piperead+0x90>
80103536:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010353c:	85 f6                	test   %esi,%esi
8010353e:	0f 84 cc 00 00 00    	je     80103610 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103544:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010354a:	eb 2d                	jmp    80103579 <piperead+0x69>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	83 ec 08             	sub    $0x8,%esp
80103553:	53                   	push   %ebx
80103554:	56                   	push   %esi
80103555:	e8 56 08 00 00       	call   80103db0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103563:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103569:	75 35                	jne    801035a0 <piperead+0x90>
8010356b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 97 00 00 00    	je     80103610 <piperead+0x100>
    if(myproc()->killed){
80103579:	e8 82 02 00 00       	call   80103800 <myproc>
8010357e:	8b 48 24             	mov    0x24(%eax),%ecx
80103581:	85 c9                	test   %ecx,%ecx
80103583:	74 cb                	je     80103550 <piperead+0x40>
      release(&p->lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
80103588:	53                   	push   %ebx
80103589:	e8 c2 0e 00 00       	call   80104450 <release>
      return -1;
8010358e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103591:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103599:	5b                   	pop    %ebx
8010359a:	5e                   	pop    %esi
8010359b:	5f                   	pop    %edi
8010359c:	5d                   	pop    %ebp
8010359d:	c3                   	ret    
8010359e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a0:	8b 45 10             	mov    0x10(%ebp),%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	7e 69                	jle    80103610 <piperead+0x100>
    if(p->nread == p->nwrite)
801035a7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035ad:	31 c9                	xor    %ecx,%ecx
801035af:	eb 15                	jmp    801035c6 <piperead+0xb6>
801035b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035b8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035be:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801035c4:	74 5a                	je     80103620 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035c6:	8d 70 01             	lea    0x1(%eax),%esi
801035c9:	25 ff 01 00 00       	and    $0x1ff,%eax
801035ce:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801035d4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801035d9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035dc:	83 c1 01             	add    $0x1,%ecx
801035df:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801035e2:	75 d4                	jne    801035b8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035e4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035ea:	83 ec 0c             	sub    $0xc,%esp
801035ed:	50                   	push   %eax
801035ee:	e8 6d 09 00 00       	call   80103f60 <wakeup>
  release(&p->lock);
801035f3:	89 1c 24             	mov    %ebx,(%esp)
801035f6:	e8 55 0e 00 00       	call   80104450 <release>
  return i;
801035fb:	8b 45 10             	mov    0x10(%ebp),%eax
801035fe:	83 c4 10             	add    $0x10,%esp
}
80103601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103604:	5b                   	pop    %ebx
80103605:	5e                   	pop    %esi
80103606:	5f                   	pop    %edi
80103607:	5d                   	pop    %ebp
80103608:	c3                   	ret    
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103610:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103617:	eb cb                	jmp    801035e4 <piperead+0xd4>
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103620:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103623:	eb bf                	jmp    801035e4 <piperead+0xd4>
80103625:	66 90                	xchg   %ax,%ax
80103627:	66 90                	xchg   %ax,%ax
80103629:	66 90                	xchg   %ax,%ax
8010362b:	66 90                	xchg   %ax,%ax
8010362d:	66 90                	xchg   %ax,%ax
8010362f:	90                   	nop

80103630 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103634:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103639:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010363c:	68 20 2d 11 80       	push   $0x80112d20
80103641:	e8 5a 0d 00 00       	call   801043a0 <acquire>
80103646:	83 c4 10             	add    $0x10,%esp
80103649:	eb 10                	jmp    8010365b <allocproc+0x2b>
8010364b:	90                   	nop
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103650:	83 c3 7c             	add    $0x7c,%ebx
80103653:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103659:	74 75                	je     801036d0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010365b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010365e:	85 c0                	test   %eax,%eax
80103660:	75 ee                	jne    80103650 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103662:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103667:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010366a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103671:	68 20 2d 11 80       	push   $0x80112d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103676:	8d 50 01             	lea    0x1(%eax),%edx
80103679:	89 43 10             	mov    %eax,0x10(%ebx)
8010367c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
80103682:	e8 c9 0d 00 00       	call   80104450 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103687:	e8 84 ee ff ff       	call   80102510 <kalloc>
8010368c:	83 c4 10             	add    $0x10,%esp
8010368f:	85 c0                	test   %eax,%eax
80103691:	89 43 08             	mov    %eax,0x8(%ebx)
80103694:	74 51                	je     801036e7 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103696:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010369c:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010369f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036a4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801036a7:	c7 40 14 b2 56 10 80 	movl   $0x801056b2,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036ae:	6a 14                	push   $0x14
801036b0:	6a 00                	push   $0x0
801036b2:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801036b3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036b6:	e8 e5 0d 00 00       	call   801044a0 <memset>
  p->context->eip = (uint)forkret;
801036bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036be:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801036c1:	c7 40 10 f0 36 10 80 	movl   $0x801036f0,0x10(%eax)

  return p;
801036c8:	89 d8                	mov    %ebx,%eax
}
801036ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036cd:	c9                   	leave  
801036ce:	c3                   	ret    
801036cf:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	68 20 2d 11 80       	push   $0x80112d20
801036d8:	e8 73 0d 00 00       	call   80104450 <release>
  return 0;
801036dd:	83 c4 10             	add    $0x10,%esp
801036e0:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801036e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036e5:	c9                   	leave  
801036e6:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801036e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036ee:	eb da                	jmp    801036ca <allocproc+0x9a>

801036f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036f6:	68 20 2d 11 80       	push   $0x80112d20
801036fb:	e8 50 0d 00 00       	call   80104450 <release>

  if (first) {
80103700:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 c0                	test   %eax,%eax
8010370a:	75 04                	jne    80103710 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010370c:	c9                   	leave  
8010370d:	c3                   	ret    
8010370e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103710:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103713:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010371a:	00 00 00 
    iinit(ROOTDEV);
8010371d:	6a 01                	push   $0x1
8010371f:	e8 4c dd ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103724:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010372b:	e8 00 f4 ff ff       	call   80102b30 <initlog>
80103730:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103733:	c9                   	leave  
80103734:	c3                   	ret    
80103735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103746:	68 b5 74 10 80       	push   $0x801074b5
8010374b:	68 20 2d 11 80       	push   $0x80112d20
80103750:	e8 eb 0a 00 00       	call   80104240 <initlock>
}
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	c9                   	leave  
80103759:	c3                   	ret    
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103760 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103765:	9c                   	pushf  
80103766:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103767:	f6 c4 02             	test   $0x2,%ah
8010376a:	75 5b                	jne    801037c7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010376c:	e8 ff ef ff ff       	call   80102770 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103771:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103777:	85 f6                	test   %esi,%esi
80103779:	7e 3f                	jle    801037ba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010377b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103782:	39 d0                	cmp    %edx,%eax
80103784:	74 30                	je     801037b6 <mycpu+0x56>
80103786:	b9 30 28 11 80       	mov    $0x80112830,%ecx
8010378b:	31 d2                	xor    %edx,%edx
8010378d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103790:	83 c2 01             	add    $0x1,%edx
80103793:	39 f2                	cmp    %esi,%edx
80103795:	74 23                	je     801037ba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103797:	0f b6 19             	movzbl (%ecx),%ebx
8010379a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037a0:	39 d8                	cmp    %ebx,%eax
801037a2:	75 ec                	jne    80103790 <mycpu+0x30>
      return &cpus[i];
801037a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801037aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037ad:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801037ae:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
801037b5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801037b6:	31 d2                	xor    %edx,%edx
801037b8:	eb ea                	jmp    801037a4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	68 bc 74 10 80       	push   $0x801074bc
801037c2:	e8 a9 cb ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801037c7:	83 ec 0c             	sub    $0xc,%esp
801037ca:	68 98 75 10 80       	push   $0x80107598
801037cf:	e8 9c cb ff ff       	call   80100370 <panic>
801037d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037e0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037e6:	e8 75 ff ff ff       	call   80103760 <mycpu>
801037eb:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
801037f0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801037f1:	c1 f8 04             	sar    $0x4,%eax
801037f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037fa:	c3                   	ret    
801037fb:	90                   	nop
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103800 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
80103804:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103807:	e8 b4 0a 00 00       	call   801042c0 <pushcli>
  c = mycpu();
8010380c:	e8 4f ff ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103811:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103817:	e8 e4 0a 00 00       	call   80104300 <popcli>
  return p;
}
8010381c:	83 c4 04             	add    $0x4,%esp
8010381f:	89 d8                	mov    %ebx,%eax
80103821:	5b                   	pop    %ebx
80103822:	5d                   	pop    %ebp
80103823:	c3                   	ret    
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
80103834:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103837:	e8 f4 fd ff ff       	call   80103630 <allocproc>
8010383c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010383e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103843:	e8 58 34 00 00       	call   80106ca0 <setupkvm>
80103848:	85 c0                	test   %eax,%eax
8010384a:	89 43 04             	mov    %eax,0x4(%ebx)
8010384d:	0f 84 bd 00 00 00    	je     80103910 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103853:	83 ec 04             	sub    $0x4,%esp
80103856:	68 2c 00 00 00       	push   $0x2c
8010385b:	68 60 a4 10 80       	push   $0x8010a460
80103860:	50                   	push   %eax
80103861:	e8 4a 31 00 00       	call   801069b0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103866:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103869:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010386f:	6a 4c                	push   $0x4c
80103871:	6a 00                	push   $0x0
80103873:	ff 73 18             	pushl  0x18(%ebx)
80103876:	e8 25 0c 00 00       	call   801044a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010387b:	8b 43 18             	mov    0x18(%ebx),%eax
8010387e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103883:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103888:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010388b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010388f:	8b 43 18             	mov    0x18(%ebx),%eax
80103892:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103896:	8b 43 18             	mov    0x18(%ebx),%eax
80103899:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010389d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038a1:	8b 43 18             	mov    0x18(%ebx),%eax
801038a4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038a8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038ac:	8b 43 18             	mov    0x18(%ebx),%eax
801038af:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038b6:	8b 43 18             	mov    0x18(%ebx),%eax
801038b9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038c0:	8b 43 18             	mov    0x18(%ebx),%eax
801038c3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801038ca:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038cd:	6a 10                	push   $0x10
801038cf:	68 e5 74 10 80       	push   $0x801074e5
801038d4:	50                   	push   %eax
801038d5:	e8 c6 0d 00 00       	call   801046a0 <safestrcpy>
  p->cwd = namei("/");
801038da:	c7 04 24 ee 74 10 80 	movl   $0x801074ee,(%esp)
801038e1:	e8 5a e6 ff ff       	call   80101f40 <namei>
801038e6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038e9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038f0:	e8 ab 0a 00 00       	call   801043a0 <acquire>

  p->state = RUNNABLE;
801038f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801038fc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103903:	e8 48 0b 00 00       	call   80104450 <release>
}
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010390e:	c9                   	leave  
8010390f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103910:	83 ec 0c             	sub    $0xc,%esp
80103913:	68 cc 74 10 80       	push   $0x801074cc
80103918:	e8 53 ca ff ff       	call   80100370 <panic>
8010391d:	8d 76 00             	lea    0x0(%esi),%esi

80103920 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
80103925:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103928:	e8 93 09 00 00       	call   801042c0 <pushcli>
  c = mycpu();
8010392d:	e8 2e fe ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103932:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103938:	e8 c3 09 00 00       	call   80104300 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010393d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103940:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103942:	7e 34                	jle    80103978 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103944:	83 ec 04             	sub    $0x4,%esp
80103947:	01 c6                	add    %eax,%esi
80103949:	56                   	push   %esi
8010394a:	50                   	push   %eax
8010394b:	ff 73 04             	pushl  0x4(%ebx)
8010394e:	e8 9d 31 00 00       	call   80106af0 <allocuvm>
80103953:	83 c4 10             	add    $0x10,%esp
80103956:	85 c0                	test   %eax,%eax
80103958:	74 36                	je     80103990 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010395a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010395d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010395f:	53                   	push   %ebx
80103960:	e8 3b 2f 00 00       	call   801068a0 <switchuvm>
  return 0;
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	31 c0                	xor    %eax,%eax
}
8010396a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010396d:	5b                   	pop    %ebx
8010396e:	5e                   	pop    %esi
8010396f:	5d                   	pop    %ebp
80103970:	c3                   	ret    
80103971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103978:	74 e0                	je     8010395a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010397a:	83 ec 04             	sub    $0x4,%esp
8010397d:	01 c6                	add    %eax,%esi
8010397f:	56                   	push   %esi
80103980:	50                   	push   %eax
80103981:	ff 73 04             	pushl  0x4(%ebx)
80103984:	e8 67 32 00 00       	call   80106bf0 <deallocuvm>
80103989:	83 c4 10             	add    $0x10,%esp
8010398c:	85 c0                	test   %eax,%eax
8010398e:	75 ca                	jne    8010395a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103995:	eb d3                	jmp    8010396a <growproc+0x4a>
80103997:	89 f6                	mov    %esi,%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
801039a4:	56                   	push   %esi
801039a5:	53                   	push   %ebx
801039a6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801039a9:	e8 12 09 00 00       	call   801042c0 <pushcli>
  c = mycpu();
801039ae:	e8 ad fd ff ff       	call   80103760 <mycpu>
  p = c->proc;
801039b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b9:	e8 42 09 00 00       	call   80104300 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
801039be:	e8 6d fc ff ff       	call   80103630 <allocproc>
801039c3:	85 c0                	test   %eax,%eax
801039c5:	89 c7                	mov    %eax,%edi
801039c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039ca:	0f 84 b5 00 00 00    	je     80103a85 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039d0:	83 ec 08             	sub    $0x8,%esp
801039d3:	ff 33                	pushl  (%ebx)
801039d5:	ff 73 04             	pushl  0x4(%ebx)
801039d8:	e8 93 33 00 00       	call   80106d70 <copyuvm>
801039dd:	83 c4 10             	add    $0x10,%esp
801039e0:	85 c0                	test   %eax,%eax
801039e2:	89 47 04             	mov    %eax,0x4(%edi)
801039e5:	0f 84 a1 00 00 00    	je     80103a8c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801039eb:	8b 03                	mov    (%ebx),%eax
801039ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039f0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039f2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801039f5:	89 c8                	mov    %ecx,%eax
801039f7:	8b 79 18             	mov    0x18(%ecx),%edi
801039fa:	8b 73 18             	mov    0x18(%ebx),%esi
801039fd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a04:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a06:	8b 40 18             	mov    0x18(%eax),%eax
80103a09:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103a10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a14:	85 c0                	test   %eax,%eax
80103a16:	74 13                	je     80103a2b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	50                   	push   %eax
80103a1c:	e8 bf d3 ff ff       	call   80100de0 <filedup>
80103a21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a24:	83 c4 10             	add    $0x10,%esp
80103a27:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a2b:	83 c6 01             	add    $0x1,%esi
80103a2e:	83 fe 10             	cmp    $0x10,%esi
80103a31:	75 dd                	jne    80103a10 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a33:	83 ec 0c             	sub    $0xc,%esp
80103a36:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a39:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a3c:	e8 3f dc ff ff       	call   80101680 <idup>
80103a41:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a44:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a47:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a4a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	53                   	push   %ebx
80103a50:	50                   	push   %eax
80103a51:	e8 4a 0c 00 00       	call   801046a0 <safestrcpy>

  pid = np->pid;
80103a56:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103a59:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a60:	e8 3b 09 00 00       	call   801043a0 <acquire>

  np->state = RUNNABLE;
80103a65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103a6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a73:	e8 d8 09 00 00       	call   80104450 <release>

  return pid;
80103a78:	83 c4 10             	add    $0x10,%esp
80103a7b:	89 d8                	mov    %ebx,%eax
}
80103a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a80:	5b                   	pop    %ebx
80103a81:	5e                   	pop    %esi
80103a82:	5f                   	pop    %edi
80103a83:	5d                   	pop    %ebp
80103a84:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a8a:	eb f1                	jmp    80103a7d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a8c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	ff 77 08             	pushl  0x8(%edi)
80103a95:	e8 c6 e8 ff ff       	call   80102360 <kfree>
    np->kstack = 0;
80103a9a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103aa1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103aa8:	83 c4 10             	add    $0x10,%esp
80103aab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ab0:	eb cb                	jmp    80103a7d <fork+0xdd>
80103ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103ac9:	e8 92 fc ff ff       	call   80103760 <mycpu>
80103ace:	8d 78 04             	lea    0x4(%eax),%edi
80103ad1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ad3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ada:	00 00 00 
80103add:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ae0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ae1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ae9:	68 20 2d 11 80       	push   $0x80112d20
80103aee:	e8 ad 08 00 00       	call   801043a0 <acquire>
80103af3:	83 c4 10             	add    $0x10,%esp
80103af6:	eb 13                	jmp    80103b0b <scheduler+0x4b>
80103af8:	90                   	nop
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b00:	83 c3 7c             	add    $0x7c,%ebx
80103b03:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103b09:	74 45                	je     80103b50 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103b0b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b0f:	75 ef                	jne    80103b00 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b11:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103b14:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b1a:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b1b:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b1e:	e8 7d 2d 00 00       	call   801068a0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103b23:	58                   	pop    %eax
80103b24:	5a                   	pop    %edx
80103b25:	ff 73 a0             	pushl  -0x60(%ebx)
80103b28:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b29:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103b30:	e8 c6 0b 00 00       	call   801046fb <swtch>
      switchkvm();
80103b35:	e8 46 2d 00 00       	call   80106880 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b3a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b3d:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b43:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b4a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b4d:	75 bc                	jne    80103b0b <scheduler+0x4b>
80103b4f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103b50:	83 ec 0c             	sub    $0xc,%esp
80103b53:	68 20 2d 11 80       	push   $0x80112d20
80103b58:	e8 f3 08 00 00       	call   80104450 <release>

  }
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	e9 7b ff ff ff       	jmp    80103ae0 <scheduler+0x20>
80103b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b70 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b75:	e8 46 07 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103b7a:	e8 e1 fb ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103b7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b85:	e8 76 07 00 00       	call   80104300 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103b8a:	83 ec 0c             	sub    $0xc,%esp
80103b8d:	68 20 2d 11 80       	push   $0x80112d20
80103b92:	e8 d9 07 00 00       	call   80104370 <holding>
80103b97:	83 c4 10             	add    $0x10,%esp
80103b9a:	85 c0                	test   %eax,%eax
80103b9c:	74 4f                	je     80103bed <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103b9e:	e8 bd fb ff ff       	call   80103760 <mycpu>
80103ba3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103baa:	75 68                	jne    80103c14 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103bac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103bb0:	74 55                	je     80103c07 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bb2:	9c                   	pushf  
80103bb3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103bb4:	f6 c4 02             	test   $0x2,%ah
80103bb7:	75 41                	jne    80103bfa <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103bb9:	e8 a2 fb ff ff       	call   80103760 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bbe:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103bc1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103bc7:	e8 94 fb ff ff       	call   80103760 <mycpu>
80103bcc:	83 ec 08             	sub    $0x8,%esp
80103bcf:	ff 70 04             	pushl  0x4(%eax)
80103bd2:	53                   	push   %ebx
80103bd3:	e8 23 0b 00 00       	call   801046fb <swtch>
  mycpu()->intena = intena;
80103bd8:	e8 83 fb ff ff       	call   80103760 <mycpu>
}
80103bdd:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103be0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103be6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be9:	5b                   	pop    %ebx
80103bea:	5e                   	pop    %esi
80103beb:	5d                   	pop    %ebp
80103bec:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103bed:	83 ec 0c             	sub    $0xc,%esp
80103bf0:	68 f0 74 10 80       	push   $0x801074f0
80103bf5:	e8 76 c7 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103bfa:	83 ec 0c             	sub    $0xc,%esp
80103bfd:	68 1c 75 10 80       	push   $0x8010751c
80103c02:	e8 69 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103c07:	83 ec 0c             	sub    $0xc,%esp
80103c0a:	68 0e 75 10 80       	push   $0x8010750e
80103c0f:	e8 5c c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103c14:	83 ec 0c             	sub    $0xc,%esp
80103c17:	68 02 75 10 80       	push   $0x80107502
80103c1c:	e8 4f c7 ff ff       	call   80100370 <panic>
80103c21:	eb 0d                	jmp    80103c30 <exit>
80103c23:	90                   	nop
80103c24:	90                   	nop
80103c25:	90                   	nop
80103c26:	90                   	nop
80103c27:	90                   	nop
80103c28:	90                   	nop
80103c29:	90                   	nop
80103c2a:	90                   	nop
80103c2b:	90                   	nop
80103c2c:	90                   	nop
80103c2d:	90                   	nop
80103c2e:	90                   	nop
80103c2f:	90                   	nop

80103c30 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c39:	e8 82 06 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103c3e:	e8 1d fb ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103c43:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c49:	e8 b2 06 00 00       	call   80104300 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103c4e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c54:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c57:	8d 7e 68             	lea    0x68(%esi),%edi
80103c5a:	0f 84 e7 00 00 00    	je     80103d47 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103c60:	8b 03                	mov    (%ebx),%eax
80103c62:	85 c0                	test   %eax,%eax
80103c64:	74 12                	je     80103c78 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c66:	83 ec 0c             	sub    $0xc,%esp
80103c69:	50                   	push   %eax
80103c6a:	e8 c1 d1 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103c6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c75:	83 c4 10             	add    $0x10,%esp
80103c78:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103c7b:	39 df                	cmp    %ebx,%edi
80103c7d:	75 e1                	jne    80103c60 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103c7f:	e8 4c ef ff ff       	call   80102bd0 <begin_op>
  iput(curproc->cwd);
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	ff 76 68             	pushl  0x68(%esi)
80103c8a:	e8 71 db ff ff       	call   80101800 <iput>
  end_op();
80103c8f:	e8 ac ef ff ff       	call   80102c40 <end_op>
  curproc->cwd = 0;
80103c94:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103c9b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ca2:	e8 f9 06 00 00       	call   801043a0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103ca7:	8b 56 14             	mov    0x14(%esi),%edx
80103caa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cad:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103cb2:	eb 0e                	jmp    80103cc2 <exit+0x92>
80103cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cb8:	83 c0 7c             	add    $0x7c,%eax
80103cbb:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103cc0:	74 1c                	je     80103cde <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103cc2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cc6:	75 f0                	jne    80103cb8 <exit+0x88>
80103cc8:	3b 50 20             	cmp    0x20(%eax),%edx
80103ccb:	75 eb                	jne    80103cb8 <exit+0x88>
      p->state = RUNNABLE;
80103ccd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cd4:	83 c0 7c             	add    $0x7c,%eax
80103cd7:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103cdc:	75 e4                	jne    80103cc2 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103cde:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103ce4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ce9:	eb 10                	jmp    80103cfb <exit+0xcb>
80103ceb:	90                   	nop
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf0:	83 c2 7c             	add    $0x7c,%edx
80103cf3:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103cf9:	74 33                	je     80103d2e <exit+0xfe>
    if(p->parent == curproc){
80103cfb:	39 72 14             	cmp    %esi,0x14(%edx)
80103cfe:	75 f0                	jne    80103cf0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d00:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103d04:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d07:	75 e7                	jne    80103cf0 <exit+0xc0>
80103d09:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d0e:	eb 0a                	jmp    80103d1a <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d10:	83 c0 7c             	add    $0x7c,%eax
80103d13:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d18:	74 d6                	je     80103cf0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d1e:	75 f0                	jne    80103d10 <exit+0xe0>
80103d20:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d23:	75 eb                	jne    80103d10 <exit+0xe0>
      p->state = RUNNABLE;
80103d25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d2c:	eb e2                	jmp    80103d10 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103d2e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d35:	e8 36 fe ff ff       	call   80103b70 <sched>
  panic("zombie exit");
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 3d 75 10 80       	push   $0x8010753d
80103d42:	e8 29 c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103d47:	83 ec 0c             	sub    $0xc,%esp
80103d4a:	68 30 75 10 80       	push   $0x80107530
80103d4f:	e8 1c c6 ff ff       	call   80100370 <panic>
80103d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d60 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	53                   	push   %ebx
80103d64:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d67:	68 20 2d 11 80       	push   $0x80112d20
80103d6c:	e8 2f 06 00 00       	call   801043a0 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d71:	e8 4a 05 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103d76:	e8 e5 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103d7b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d81:	e8 7a 05 00 00       	call   80104300 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103d86:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d8d:	e8 de fd ff ff       	call   80103b70 <sched>
  release(&ptable.lock);
80103d92:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d99:	e8 b2 06 00 00       	call   80104450 <release>
}
80103d9e:	83 c4 10             	add    $0x10,%esp
80103da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da4:	c9                   	leave  
80103da5:	c3                   	ret    
80103da6:	8d 76 00             	lea    0x0(%esi),%esi
80103da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103db0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 0c             	sub    $0xc,%esp
80103db9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dbc:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103dbf:	e8 fc 04 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103dc4:	e8 97 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103dc9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dcf:	e8 2c 05 00 00       	call   80104300 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103dd4:	85 db                	test   %ebx,%ebx
80103dd6:	0f 84 87 00 00 00    	je     80103e63 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103ddc:	85 f6                	test   %esi,%esi
80103dde:	74 76                	je     80103e56 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103de0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103de6:	74 50                	je     80103e38 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103de8:	83 ec 0c             	sub    $0xc,%esp
80103deb:	68 20 2d 11 80       	push   $0x80112d20
80103df0:	e8 ab 05 00 00       	call   801043a0 <acquire>
    release(lk);
80103df5:	89 34 24             	mov    %esi,(%esp)
80103df8:	e8 53 06 00 00       	call   80104450 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103dfd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e00:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e07:	e8 64 fd ff ff       	call   80103b70 <sched>

  // Tidy up.
  p->chan = 0;
80103e0c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e13:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e1a:	e8 31 06 00 00       	call   80104450 <release>
    acquire(lk);
80103e1f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e22:	83 c4 10             	add    $0x10,%esp
  }
}
80103e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e28:	5b                   	pop    %ebx
80103e29:	5e                   	pop    %esi
80103e2a:	5f                   	pop    %edi
80103e2b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e2c:	e9 6f 05 00 00       	jmp    801043a0 <acquire>
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103e38:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e3b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e42:	e8 29 fd ff ff       	call   80103b70 <sched>

  // Tidy up.
  p->chan = 0;
80103e47:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e51:	5b                   	pop    %ebx
80103e52:	5e                   	pop    %esi
80103e53:	5f                   	pop    %edi
80103e54:	5d                   	pop    %ebp
80103e55:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103e56:	83 ec 0c             	sub    $0xc,%esp
80103e59:	68 4f 75 10 80       	push   $0x8010754f
80103e5e:	e8 0d c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	68 49 75 10 80       	push   $0x80107549
80103e6b:	e8 00 c5 ff ff       	call   80100370 <panic>

80103e70 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	56                   	push   %esi
80103e74:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e75:	e8 46 04 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103e7a:	e8 e1 f8 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103e7f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e85:	e8 76 04 00 00       	call   80104300 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	68 20 2d 11 80       	push   $0x80112d20
80103e92:	e8 09 05 00 00       	call   801043a0 <acquire>
80103e97:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103e9a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e9c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ea1:	eb 10                	jmp    80103eb3 <wait+0x43>
80103ea3:	90                   	nop
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea8:	83 c3 7c             	add    $0x7c,%ebx
80103eab:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103eb1:	74 1d                	je     80103ed0 <wait+0x60>
      if(p->parent != curproc)
80103eb3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103eb6:	75 f0                	jne    80103ea8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103eb8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103ebc:	74 30                	je     80103eee <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ebe:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103ec1:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103ecc:	75 e5                	jne    80103eb3 <wait+0x43>
80103ece:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103ed0:	85 c0                	test   %eax,%eax
80103ed2:	74 70                	je     80103f44 <wait+0xd4>
80103ed4:	8b 46 24             	mov    0x24(%esi),%eax
80103ed7:	85 c0                	test   %eax,%eax
80103ed9:	75 69                	jne    80103f44 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103edb:	83 ec 08             	sub    $0x8,%esp
80103ede:	68 20 2d 11 80       	push   $0x80112d20
80103ee3:	56                   	push   %esi
80103ee4:	e8 c7 fe ff ff       	call   80103db0 <sleep>
  }
80103ee9:	83 c4 10             	add    $0x10,%esp
80103eec:	eb ac                	jmp    80103e9a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103eee:	83 ec 0c             	sub    $0xc,%esp
80103ef1:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103ef4:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103ef7:	e8 64 e4 ff ff       	call   80102360 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103efc:	5a                   	pop    %edx
80103efd:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f00:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f07:	e8 14 2d 00 00       	call   80106c20 <freevm>
        p->pid = 0;
80103f0c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f13:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f1a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f1e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f25:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f33:	e8 18 05 00 00       	call   80104450 <release>
        return pid;
80103f38:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f3e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f40:	5b                   	pop    %ebx
80103f41:	5e                   	pop    %esi
80103f42:	5d                   	pop    %ebp
80103f43:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 20 2d 11 80       	push   $0x80112d20
80103f4c:	e8 ff 04 00 00       	call   80104450 <release>
      return -1;
80103f51:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f54:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f5c:	5b                   	pop    %ebx
80103f5d:	5e                   	pop    %esi
80103f5e:	5d                   	pop    %ebp
80103f5f:	c3                   	ret    

80103f60 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
80103f64:	83 ec 10             	sub    $0x10,%esp
80103f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f6a:	68 20 2d 11 80       	push   $0x80112d20
80103f6f:	e8 2c 04 00 00       	call   801043a0 <acquire>
80103f74:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f77:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f7c:	eb 0c                	jmp    80103f8a <wakeup+0x2a>
80103f7e:	66 90                	xchg   %ax,%ax
80103f80:	83 c0 7c             	add    $0x7c,%eax
80103f83:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f88:	74 1c                	je     80103fa6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103f8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f8e:	75 f0                	jne    80103f80 <wakeup+0x20>
80103f90:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f93:	75 eb                	jne    80103f80 <wakeup+0x20>
      p->state = RUNNABLE;
80103f95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f9c:	83 c0 7c             	add    $0x7c,%eax
80103f9f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103fa4:	75 e4                	jne    80103f8a <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fa6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fb0:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fb1:	e9 9a 04 00 00       	jmp    80104450 <release>
80103fb6:	8d 76 00             	lea    0x0(%esi),%esi
80103fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fc0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	53                   	push   %ebx
80103fc4:	83 ec 10             	sub    $0x10,%esp
80103fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103fca:	68 20 2d 11 80       	push   $0x80112d20
80103fcf:	e8 cc 03 00 00       	call   801043a0 <acquire>
80103fd4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fdc:	eb 0c                	jmp    80103fea <kill+0x2a>
80103fde:	66 90                	xchg   %ax,%ax
80103fe0:	83 c0 7c             	add    $0x7c,%eax
80103fe3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103fe8:	74 3e                	je     80104028 <kill+0x68>
    if(p->pid == pid){
80103fea:	39 58 10             	cmp    %ebx,0x10(%eax)
80103fed:	75 f1                	jne    80103fe0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fef:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103ff3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103ffa:	74 1c                	je     80104018 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103ffc:	83 ec 0c             	sub    $0xc,%esp
80103fff:	68 20 2d 11 80       	push   $0x80112d20
80104004:	e8 47 04 00 00       	call   80104450 <release>
      return 0;
80104009:	83 c4 10             	add    $0x10,%esp
8010400c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010400e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104011:	c9                   	leave  
80104012:	c3                   	ret    
80104013:	90                   	nop
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104018:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010401f:	eb db                	jmp    80103ffc <kill+0x3c>
80104021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	68 20 2d 11 80       	push   $0x80112d20
80104030:	e8 1b 04 00 00       	call   80104450 <release>
  return -1;
80104035:	83 c4 10             	add    $0x10,%esp
80104038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010403d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104040:	c9                   	leave  
80104041:	c3                   	ret    
80104042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104050 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104059:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010405e:	83 ec 3c             	sub    $0x3c,%esp
80104061:	eb 24                	jmp    80104087 <procdump+0x37>
80104063:	90                   	nop
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	68 d7 78 10 80       	push   $0x801078d7
80104070:	e8 eb c5 ff ff       	call   80100660 <cprintf>
80104075:	83 c4 10             	add    $0x10,%esp
80104078:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104081:	0f 84 81 00 00 00    	je     80104108 <procdump+0xb8>
    if(p->state == UNUSED)
80104087:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010408a:	85 c0                	test   %eax,%eax
8010408c:	74 ea                	je     80104078 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010408e:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104091:	ba 60 75 10 80       	mov    $0x80107560,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104096:	77 11                	ja     801040a9 <procdump+0x59>
80104098:	8b 14 85 c0 75 10 80 	mov    -0x7fef8a40(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010409f:	b8 60 75 10 80       	mov    $0x80107560,%eax
801040a4:	85 d2                	test   %edx,%edx
801040a6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040a9:	53                   	push   %ebx
801040aa:	52                   	push   %edx
801040ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801040ae:	68 64 75 10 80       	push   $0x80107564
801040b3:	e8 a8 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040b8:	83 c4 10             	add    $0x10,%esp
801040bb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801040bf:	75 a7                	jne    80104068 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040c1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040c4:	83 ec 08             	sub    $0x8,%esp
801040c7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040ca:	50                   	push   %eax
801040cb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801040ce:	8b 40 0c             	mov    0xc(%eax),%eax
801040d1:	83 c0 08             	add    $0x8,%eax
801040d4:	50                   	push   %eax
801040d5:	e8 86 01 00 00       	call   80104260 <getcallerpcs>
801040da:	83 c4 10             	add    $0x10,%esp
801040dd:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801040e0:	8b 17                	mov    (%edi),%edx
801040e2:	85 d2                	test   %edx,%edx
801040e4:	74 82                	je     80104068 <procdump+0x18>
        cprintf(" %p", pc[i]);
801040e6:	83 ec 08             	sub    $0x8,%esp
801040e9:	83 c7 04             	add    $0x4,%edi
801040ec:	52                   	push   %edx
801040ed:	68 a1 6f 10 80       	push   $0x80106fa1
801040f2:	e8 69 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801040f7:	83 c4 10             	add    $0x10,%esp
801040fa:	39 f7                	cmp    %esi,%edi
801040fc:	75 e2                	jne    801040e0 <procdump+0x90>
801040fe:	e9 65 ff ff ff       	jmp    80104068 <procdump+0x18>
80104103:	90                   	nop
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104108:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010410b:	5b                   	pop    %ebx
8010410c:	5e                   	pop    %esi
8010410d:	5f                   	pop    %edi
8010410e:	5d                   	pop    %ebp
8010410f:	c3                   	ret    

80104110 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010411a:	68 d8 75 10 80       	push   $0x801075d8
8010411f:	8d 43 04             	lea    0x4(%ebx),%eax
80104122:	50                   	push   %eax
80104123:	e8 18 01 00 00       	call   80104240 <initlock>
  lk->name = name;
80104128:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010412b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104131:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104134:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010413b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010413e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104141:	c9                   	leave  
80104142:	c3                   	ret    
80104143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104150 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
80104155:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	8d 73 04             	lea    0x4(%ebx),%esi
8010415e:	56                   	push   %esi
8010415f:	e8 3c 02 00 00       	call   801043a0 <acquire>
  while (lk->locked) {
80104164:	8b 13                	mov    (%ebx),%edx
80104166:	83 c4 10             	add    $0x10,%esp
80104169:	85 d2                	test   %edx,%edx
8010416b:	74 16                	je     80104183 <acquiresleep+0x33>
8010416d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104170:	83 ec 08             	sub    $0x8,%esp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
80104175:	e8 36 fc ff ff       	call   80103db0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010417a:	8b 03                	mov    (%ebx),%eax
8010417c:	83 c4 10             	add    $0x10,%esp
8010417f:	85 c0                	test   %eax,%eax
80104181:	75 ed                	jne    80104170 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104183:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104189:	e8 72 f6 ff ff       	call   80103800 <myproc>
8010418e:	8b 40 10             	mov    0x10(%eax),%eax
80104191:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104194:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104197:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010419a:	5b                   	pop    %ebx
8010419b:	5e                   	pop    %esi
8010419c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010419d:	e9 ae 02 00 00       	jmp    80104450 <release>
801041a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	8d 73 04             	lea    0x4(%ebx),%esi
801041be:	56                   	push   %esi
801041bf:	e8 dc 01 00 00       	call   801043a0 <acquire>
  lk->locked = 0;
801041c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801041d1:	89 1c 24             	mov    %ebx,(%esp)
801041d4:	e8 87 fd ff ff       	call   80103f60 <wakeup>
  release(&lk->lk);
801041d9:	89 75 08             	mov    %esi,0x8(%ebp)
801041dc:	83 c4 10             	add    $0x10,%esp
}
801041df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e2:	5b                   	pop    %ebx
801041e3:	5e                   	pop    %esi
801041e4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801041e5:	e9 66 02 00 00       	jmp    80104450 <release>
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	53                   	push   %ebx
801041f6:	31 ff                	xor    %edi,%edi
801041f8:	83 ec 18             	sub    $0x18,%esp
801041fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801041fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104201:	56                   	push   %esi
80104202:	e8 99 01 00 00       	call   801043a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104207:	8b 03                	mov    (%ebx),%eax
80104209:	83 c4 10             	add    $0x10,%esp
8010420c:	85 c0                	test   %eax,%eax
8010420e:	74 13                	je     80104223 <holdingsleep+0x33>
80104210:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104213:	e8 e8 f5 ff ff       	call   80103800 <myproc>
80104218:	39 58 10             	cmp    %ebx,0x10(%eax)
8010421b:	0f 94 c0             	sete   %al
8010421e:	0f b6 c0             	movzbl %al,%eax
80104221:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104223:	83 ec 0c             	sub    $0xc,%esp
80104226:	56                   	push   %esi
80104227:	e8 24 02 00 00       	call   80104450 <release>
  return r;
}
8010422c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010422f:	89 f8                	mov    %edi,%eax
80104231:	5b                   	pop    %ebx
80104232:	5e                   	pop    %esi
80104233:	5f                   	pop    %edi
80104234:	5d                   	pop    %ebp
80104235:	c3                   	ret    
80104236:	66 90                	xchg   %ax,%ax
80104238:	66 90                	xchg   %ax,%ax
8010423a:	66 90                	xchg   %ax,%ax
8010423c:	66 90                	xchg   %ax,%ax
8010423e:	66 90                	xchg   %ax,%ax

80104240 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104246:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010424f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104252:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104259:	5d                   	pop    %ebp
8010425a:	c3                   	ret    
8010425b:	90                   	nop
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104264:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010426a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010426d:	31 c0                	xor    %eax,%eax
8010426f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104270:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104276:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010427c:	77 1a                	ja     80104298 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010427e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104281:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104284:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104287:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104289:	83 f8 0a             	cmp    $0xa,%eax
8010428c:	75 e2                	jne    80104270 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010428e:	5b                   	pop    %ebx
8010428f:	5d                   	pop    %ebp
80104290:	c3                   	ret    
80104291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104298:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010429f:	83 c0 01             	add    $0x1,%eax
801042a2:	83 f8 0a             	cmp    $0xa,%eax
801042a5:	74 e7                	je     8010428e <getcallerpcs+0x2e>
    pcs[i] = 0;
801042a7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042ae:	83 c0 01             	add    $0x1,%eax
801042b1:	83 f8 0a             	cmp    $0xa,%eax
801042b4:	75 e2                	jne    80104298 <getcallerpcs+0x38>
801042b6:	eb d6                	jmp    8010428e <getcallerpcs+0x2e>
801042b8:	90                   	nop
801042b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 04             	sub    $0x4,%esp
801042c7:	9c                   	pushf  
801042c8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801042ca:	e8 91 f4 ff ff       	call   80103760 <mycpu>
801042cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042d5:	85 c0                	test   %eax,%eax
801042d7:	75 11                	jne    801042ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801042d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801042df:	e8 7c f4 ff ff       	call   80103760 <mycpu>
801042e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801042ea:	e8 71 f4 ff ff       	call   80103760 <mycpu>
801042ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801042f6:	83 c4 04             	add    $0x4,%esp
801042f9:	5b                   	pop    %ebx
801042fa:	5d                   	pop    %ebp
801042fb:	c3                   	ret    
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104300 <popcli>:

void
popcli(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104306:	9c                   	pushf  
80104307:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104308:	f6 c4 02             	test   $0x2,%ah
8010430b:	75 52                	jne    8010435f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010430d:	e8 4e f4 ff ff       	call   80103760 <mycpu>
80104312:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104318:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010431b:	85 d2                	test   %edx,%edx
8010431d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104323:	78 2d                	js     80104352 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104325:	e8 36 f4 ff ff       	call   80103760 <mycpu>
8010432a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104330:	85 d2                	test   %edx,%edx
80104332:	74 0c                	je     80104340 <popcli+0x40>
    sti();
}
80104334:	c9                   	leave  
80104335:	c3                   	ret    
80104336:	8d 76 00             	lea    0x0(%esi),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104340:	e8 1b f4 ff ff       	call   80103760 <mycpu>
80104345:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010434b:	85 c0                	test   %eax,%eax
8010434d:	74 e5                	je     80104334 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010434f:	fb                   	sti    
    sti();
}
80104350:	c9                   	leave  
80104351:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104352:	83 ec 0c             	sub    $0xc,%esp
80104355:	68 fa 75 10 80       	push   $0x801075fa
8010435a:	e8 11 c0 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010435f:	83 ec 0c             	sub    $0xc,%esp
80104362:	68 e3 75 10 80       	push   $0x801075e3
80104367:	e8 04 c0 ff ff       	call   80100370 <panic>
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104370 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	8b 75 08             	mov    0x8(%ebp),%esi
80104378:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010437a:	e8 41 ff ff ff       	call   801042c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010437f:	8b 06                	mov    (%esi),%eax
80104381:	85 c0                	test   %eax,%eax
80104383:	74 10                	je     80104395 <holding+0x25>
80104385:	8b 5e 08             	mov    0x8(%esi),%ebx
80104388:	e8 d3 f3 ff ff       	call   80103760 <mycpu>
8010438d:	39 c3                	cmp    %eax,%ebx
8010438f:	0f 94 c3             	sete   %bl
80104392:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104395:	e8 66 ff ff ff       	call   80104300 <popcli>
  return r;
}
8010439a:	89 d8                	mov    %ebx,%eax
8010439c:	5b                   	pop    %ebx
8010439d:	5e                   	pop    %esi
8010439e:	5d                   	pop    %ebp
8010439f:	c3                   	ret    

801043a0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801043a7:	e8 14 ff ff ff       	call   801042c0 <pushcli>
  if(holding(lk))
801043ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043af:	83 ec 0c             	sub    $0xc,%esp
801043b2:	53                   	push   %ebx
801043b3:	e8 b8 ff ff ff       	call   80104370 <holding>
801043b8:	83 c4 10             	add    $0x10,%esp
801043bb:	85 c0                	test   %eax,%eax
801043bd:	0f 85 7d 00 00 00    	jne    80104440 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801043c3:	ba 01 00 00 00       	mov    $0x1,%edx
801043c8:	eb 09                	jmp    801043d3 <acquire+0x33>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043d3:	89 d0                	mov    %edx,%eax
801043d5:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801043d8:	85 c0                	test   %eax,%eax
801043da:	75 f4                	jne    801043d0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801043dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801043e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043e4:	e8 77 f3 ff ff       	call   80103760 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801043e9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801043eb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801043ee:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043f1:	31 c0                	xor    %eax,%eax
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043f8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801043fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104404:	77 1a                	ja     80104420 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104406:	8b 5a 04             	mov    0x4(%edx),%ebx
80104409:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010440c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010440f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104411:	83 f8 0a             	cmp    $0xa,%eax
80104414:	75 e2                	jne    801043f8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104416:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104419:	c9                   	leave  
8010441a:	c3                   	ret    
8010441b:	90                   	nop
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104420:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104427:	83 c0 01             	add    $0x1,%eax
8010442a:	83 f8 0a             	cmp    $0xa,%eax
8010442d:	74 e7                	je     80104416 <acquire+0x76>
    pcs[i] = 0;
8010442f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104436:	83 c0 01             	add    $0x1,%eax
80104439:	83 f8 0a             	cmp    $0xa,%eax
8010443c:	75 e2                	jne    80104420 <acquire+0x80>
8010443e:	eb d6                	jmp    80104416 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	68 01 76 10 80       	push   $0x80107601
80104448:	e8 23 bf ff ff       	call   80100370 <panic>
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 10             	sub    $0x10,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010445a:	53                   	push   %ebx
8010445b:	e8 10 ff ff ff       	call   80104370 <holding>
80104460:	83 c4 10             	add    $0x10,%esp
80104463:	85 c0                	test   %eax,%eax
80104465:	74 22                	je     80104489 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104467:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010446e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104475:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010447a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104483:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104484:	e9 77 fe ff ff       	jmp    80104300 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104489:	83 ec 0c             	sub    $0xc,%esp
8010448c:	68 09 76 10 80       	push   $0x80107609
80104491:	e8 da be ff ff       	call   80100370 <panic>
80104496:	66 90                	xchg   %ax,%ax
80104498:	66 90                	xchg   %ax,%ax
8010449a:	66 90                	xchg   %ax,%ax
8010449c:	66 90                	xchg   %ax,%ax
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	53                   	push   %ebx
801044a5:	8b 55 08             	mov    0x8(%ebp),%edx
801044a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044ab:	f6 c2 03             	test   $0x3,%dl
801044ae:	75 05                	jne    801044b5 <memset+0x15>
801044b0:	f6 c1 03             	test   $0x3,%cl
801044b3:	74 13                	je     801044c8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801044b5:	89 d7                	mov    %edx,%edi
801044b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ba:	fc                   	cld    
801044bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044bd:	5b                   	pop    %ebx
801044be:	89 d0                	mov    %edx,%eax
801044c0:	5f                   	pop    %edi
801044c1:	5d                   	pop    %ebp
801044c2:	c3                   	ret    
801044c3:	90                   	nop
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801044c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801044cc:	c1 e9 02             	shr    $0x2,%ecx
801044cf:	89 fb                	mov    %edi,%ebx
801044d1:	89 f8                	mov    %edi,%eax
801044d3:	c1 e3 18             	shl    $0x18,%ebx
801044d6:	c1 e0 10             	shl    $0x10,%eax
801044d9:	09 d8                	or     %ebx,%eax
801044db:	09 f8                	or     %edi,%eax
801044dd:	c1 e7 08             	shl    $0x8,%edi
801044e0:	09 f8                	or     %edi,%eax
801044e2:	89 d7                	mov    %edx,%edi
801044e4:	fc                   	cld    
801044e5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044e7:	5b                   	pop    %ebx
801044e8:	89 d0                	mov    %edx,%eax
801044ea:	5f                   	pop    %edi
801044eb:	5d                   	pop    %ebp
801044ec:	c3                   	ret    
801044ed:	8d 76 00             	lea    0x0(%esi),%esi

801044f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	8b 45 10             	mov    0x10(%ebp),%eax
801044f8:	53                   	push   %ebx
801044f9:	8b 75 0c             	mov    0xc(%ebp),%esi
801044fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044ff:	85 c0                	test   %eax,%eax
80104501:	74 29                	je     8010452c <memcmp+0x3c>
    if(*s1 != *s2)
80104503:	0f b6 13             	movzbl (%ebx),%edx
80104506:	0f b6 0e             	movzbl (%esi),%ecx
80104509:	38 d1                	cmp    %dl,%cl
8010450b:	75 2b                	jne    80104538 <memcmp+0x48>
8010450d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104510:	31 c0                	xor    %eax,%eax
80104512:	eb 14                	jmp    80104528 <memcmp+0x38>
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104518:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010451d:	83 c0 01             	add    $0x1,%eax
80104520:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104524:	38 ca                	cmp    %cl,%dl
80104526:	75 10                	jne    80104538 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104528:	39 f8                	cmp    %edi,%eax
8010452a:	75 ec                	jne    80104518 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010452c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010452d:	31 c0                	xor    %eax,%eax
}
8010452f:	5e                   	pop    %esi
80104530:	5f                   	pop    %edi
80104531:	5d                   	pop    %ebp
80104532:	c3                   	ret    
80104533:	90                   	nop
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104538:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010453b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010453c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010453e:	5e                   	pop    %esi
8010453f:	5f                   	pop    %edi
80104540:	5d                   	pop    %ebp
80104541:	c3                   	ret    
80104542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104550 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 45 08             	mov    0x8(%ebp),%eax
80104558:	8b 75 0c             	mov    0xc(%ebp),%esi
8010455b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010455e:	39 c6                	cmp    %eax,%esi
80104560:	73 2e                	jae    80104590 <memmove+0x40>
80104562:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104565:	39 c8                	cmp    %ecx,%eax
80104567:	73 27                	jae    80104590 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104569:	85 db                	test   %ebx,%ebx
8010456b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010456e:	74 17                	je     80104587 <memmove+0x37>
      *--d = *--s;
80104570:	29 d9                	sub    %ebx,%ecx
80104572:	89 cb                	mov    %ecx,%ebx
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104578:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010457c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010457f:	83 ea 01             	sub    $0x1,%edx
80104582:	83 fa ff             	cmp    $0xffffffff,%edx
80104585:	75 f1                	jne    80104578 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104587:	5b                   	pop    %ebx
80104588:	5e                   	pop    %esi
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret    
8010458b:	90                   	nop
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104590:	31 d2                	xor    %edx,%edx
80104592:	85 db                	test   %ebx,%ebx
80104594:	74 f1                	je     80104587 <memmove+0x37>
80104596:	8d 76 00             	lea    0x0(%esi),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801045a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045a7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045aa:	39 d3                	cmp    %edx,%ebx
801045ac:	75 f2                	jne    801045a0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801045ae:	5b                   	pop    %ebx
801045af:	5e                   	pop    %esi
801045b0:	5d                   	pop    %ebp
801045b1:	c3                   	ret    
801045b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045c3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801045c4:	eb 8a                	jmp    80104550 <memmove>
801045c6:	8d 76 00             	lea    0x0(%esi),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045d8:	53                   	push   %ebx
801045d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801045df:	85 c9                	test   %ecx,%ecx
801045e1:	74 37                	je     8010461a <strncmp+0x4a>
801045e3:	0f b6 17             	movzbl (%edi),%edx
801045e6:	0f b6 1e             	movzbl (%esi),%ebx
801045e9:	84 d2                	test   %dl,%dl
801045eb:	74 3f                	je     8010462c <strncmp+0x5c>
801045ed:	38 d3                	cmp    %dl,%bl
801045ef:	75 3b                	jne    8010462c <strncmp+0x5c>
801045f1:	8d 47 01             	lea    0x1(%edi),%eax
801045f4:	01 cf                	add    %ecx,%edi
801045f6:	eb 1b                	jmp    80104613 <strncmp+0x43>
801045f8:	90                   	nop
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104600:	0f b6 10             	movzbl (%eax),%edx
80104603:	84 d2                	test   %dl,%dl
80104605:	74 21                	je     80104628 <strncmp+0x58>
80104607:	0f b6 19             	movzbl (%ecx),%ebx
8010460a:	83 c0 01             	add    $0x1,%eax
8010460d:	89 ce                	mov    %ecx,%esi
8010460f:	38 da                	cmp    %bl,%dl
80104611:	75 19                	jne    8010462c <strncmp+0x5c>
80104613:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104615:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104618:	75 e6                	jne    80104600 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010461a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010461b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010461d:	5e                   	pop    %esi
8010461e:	5f                   	pop    %edi
8010461f:	5d                   	pop    %ebp
80104620:	c3                   	ret    
80104621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104628:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010462c:	0f b6 c2             	movzbl %dl,%eax
8010462f:	29 d8                	sub    %ebx,%eax
}
80104631:	5b                   	pop    %ebx
80104632:	5e                   	pop    %esi
80104633:	5f                   	pop    %edi
80104634:	5d                   	pop    %ebp
80104635:	c3                   	ret    
80104636:	8d 76 00             	lea    0x0(%esi),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 45 08             	mov    0x8(%ebp),%eax
80104648:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010464b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010464e:	89 c2                	mov    %eax,%edx
80104650:	eb 19                	jmp    8010466b <strncpy+0x2b>
80104652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104658:	83 c3 01             	add    $0x1,%ebx
8010465b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010465f:	83 c2 01             	add    $0x1,%edx
80104662:	84 c9                	test   %cl,%cl
80104664:	88 4a ff             	mov    %cl,-0x1(%edx)
80104667:	74 09                	je     80104672 <strncpy+0x32>
80104669:	89 f1                	mov    %esi,%ecx
8010466b:	85 c9                	test   %ecx,%ecx
8010466d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104670:	7f e6                	jg     80104658 <strncpy+0x18>
    ;
  while(n-- > 0)
80104672:	31 c9                	xor    %ecx,%ecx
80104674:	85 f6                	test   %esi,%esi
80104676:	7e 17                	jle    8010468f <strncpy+0x4f>
80104678:	90                   	nop
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104680:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104684:	89 f3                	mov    %esi,%ebx
80104686:	83 c1 01             	add    $0x1,%ecx
80104689:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010468b:	85 db                	test   %ebx,%ebx
8010468d:	7f f1                	jg     80104680 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010468f:	5b                   	pop    %ebx
80104690:	5e                   	pop    %esi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046a8:	8b 45 08             	mov    0x8(%ebp),%eax
801046ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046ae:	85 c9                	test   %ecx,%ecx
801046b0:	7e 26                	jle    801046d8 <safestrcpy+0x38>
801046b2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046b6:	89 c1                	mov    %eax,%ecx
801046b8:	eb 17                	jmp    801046d1 <safestrcpy+0x31>
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046c0:	83 c2 01             	add    $0x1,%edx
801046c3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046c7:	83 c1 01             	add    $0x1,%ecx
801046ca:	84 db                	test   %bl,%bl
801046cc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046cf:	74 04                	je     801046d5 <safestrcpy+0x35>
801046d1:	39 f2                	cmp    %esi,%edx
801046d3:	75 eb                	jne    801046c0 <safestrcpy+0x20>
    ;
  *s = 0;
801046d5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046d8:	5b                   	pop    %ebx
801046d9:	5e                   	pop    %esi
801046da:	5d                   	pop    %ebp
801046db:	c3                   	ret    
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <strlen>:

int
strlen(const char *s)
{
801046e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046e1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801046e8:	80 3a 00             	cmpb   $0x0,(%edx)
801046eb:	74 0c                	je     801046f9 <strlen+0x19>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi
801046f0:	83 c0 01             	add    $0x1,%eax
801046f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046f7:	75 f7                	jne    801046f0 <strlen+0x10>
    ;
  return n;
}
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    

801046fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104703:	55                   	push   %ebp
  pushl %ebx
80104704:	53                   	push   %ebx
  pushl %esi
80104705:	56                   	push   %esi
  pushl %edi
80104706:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104707:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104709:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010470b:	5f                   	pop    %edi
  popl %esi
8010470c:	5e                   	pop    %esi
  popl %ebx
8010470d:	5b                   	pop    %ebx
  popl %ebp
8010470e:	5d                   	pop    %ebp
  ret
8010470f:	c3                   	ret    

80104710 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010471a:	e8 e1 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010471f:	8b 00                	mov    (%eax),%eax
80104721:	39 d8                	cmp    %ebx,%eax
80104723:	76 1b                	jbe    80104740 <fetchint+0x30>
80104725:	8d 53 04             	lea    0x4(%ebx),%edx
80104728:	39 d0                	cmp    %edx,%eax
8010472a:	72 14                	jb     80104740 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010472c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010472f:	8b 13                	mov    (%ebx),%edx
80104731:	89 10                	mov    %edx,(%eax)
  return 0;
80104733:	31 c0                	xor    %eax,%eax
}
80104735:	83 c4 04             	add    $0x4,%esp
80104738:	5b                   	pop    %ebx
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104745:	eb ee                	jmp    80104735 <fetchint+0x25>
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104750 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 04             	sub    $0x4,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010475a:	e8 a1 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz)
8010475f:	39 18                	cmp    %ebx,(%eax)
80104761:	76 29                	jbe    8010478c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104763:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104766:	89 da                	mov    %ebx,%edx
80104768:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010476a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010476c:	39 c3                	cmp    %eax,%ebx
8010476e:	73 1c                	jae    8010478c <fetchstr+0x3c>
    if(*s == 0)
80104770:	80 3b 00             	cmpb   $0x0,(%ebx)
80104773:	75 10                	jne    80104785 <fetchstr+0x35>
80104775:	eb 29                	jmp    801047a0 <fetchstr+0x50>
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104780:	80 3a 00             	cmpb   $0x0,(%edx)
80104783:	74 1b                	je     801047a0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104785:	83 c2 01             	add    $0x1,%edx
80104788:	39 d0                	cmp    %edx,%eax
8010478a:	77 f4                	ja     80104780 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010478c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010478f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104794:	5b                   	pop    %ebx
80104795:	5d                   	pop    %ebp
80104796:	c3                   	ret    
80104797:	89 f6                	mov    %esi,%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047a0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801047a3:	89 d0                	mov    %edx,%eax
801047a5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801047a7:	5b                   	pop    %ebx
801047a8:	5d                   	pop    %ebp
801047a9:	c3                   	ret    
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047b5:	e8 46 f0 ff ff       	call   80103800 <myproc>
801047ba:	8b 40 18             	mov    0x18(%eax),%eax
801047bd:	8b 55 08             	mov    0x8(%ebp),%edx
801047c0:	8b 40 44             	mov    0x44(%eax),%eax
801047c3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
801047c6:	e8 35 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047cb:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047cd:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047d0:	39 c6                	cmp    %eax,%esi
801047d2:	73 1c                	jae    801047f0 <argint+0x40>
801047d4:	8d 53 08             	lea    0x8(%ebx),%edx
801047d7:	39 d0                	cmp    %edx,%eax
801047d9:	72 15                	jb     801047f0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801047db:	8b 45 0c             	mov    0xc(%ebp),%eax
801047de:	8b 53 04             	mov    0x4(%ebx),%edx
801047e1:	89 10                	mov    %edx,(%eax)
  return 0;
801047e3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801047e5:	5b                   	pop    %ebx
801047e6:	5e                   	pop    %esi
801047e7:	5d                   	pop    %ebp
801047e8:	c3                   	ret    
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801047f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f5:	eb ee                	jmp    801047e5 <argint+0x35>
801047f7:	89 f6                	mov    %esi,%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	83 ec 10             	sub    $0x10,%esp
80104808:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010480b:	e8 f0 ef ff ff       	call   80103800 <myproc>
80104810:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104812:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104815:	83 ec 08             	sub    $0x8,%esp
80104818:	50                   	push   %eax
80104819:	ff 75 08             	pushl  0x8(%ebp)
8010481c:	e8 8f ff ff ff       	call   801047b0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104821:	c1 e8 1f             	shr    $0x1f,%eax
80104824:	83 c4 10             	add    $0x10,%esp
80104827:	84 c0                	test   %al,%al
80104829:	75 2d                	jne    80104858 <argptr+0x58>
8010482b:	89 d8                	mov    %ebx,%eax
8010482d:	c1 e8 1f             	shr    $0x1f,%eax
80104830:	84 c0                	test   %al,%al
80104832:	75 24                	jne    80104858 <argptr+0x58>
80104834:	8b 16                	mov    (%esi),%edx
80104836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104839:	39 c2                	cmp    %eax,%edx
8010483b:	76 1b                	jbe    80104858 <argptr+0x58>
8010483d:	01 c3                	add    %eax,%ebx
8010483f:	39 da                	cmp    %ebx,%edx
80104841:	72 15                	jb     80104858 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104843:	8b 55 0c             	mov    0xc(%ebp),%edx
80104846:	89 02                	mov    %eax,(%edx)
  return 0;
80104848:	31 c0                	xor    %eax,%eax
}
8010484a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484d:	5b                   	pop    %ebx
8010484e:	5e                   	pop    %esi
8010484f:	5d                   	pop    %ebp
80104850:	c3                   	ret    
80104851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010485d:	eb eb                	jmp    8010484a <argptr+0x4a>
8010485f:	90                   	nop

80104860 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104866:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104869:	50                   	push   %eax
8010486a:	ff 75 08             	pushl  0x8(%ebp)
8010486d:	e8 3e ff ff ff       	call   801047b0 <argint>
80104872:	83 c4 10             	add    $0x10,%esp
80104875:	85 c0                	test   %eax,%eax
80104877:	78 17                	js     80104890 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104879:	83 ec 08             	sub    $0x8,%esp
8010487c:	ff 75 0c             	pushl  0xc(%ebp)
8010487f:	ff 75 f4             	pushl  -0xc(%ebp)
80104882:	e8 c9 fe ff ff       	call   80104750 <fetchstr>
80104887:	83 c4 10             	add    $0x10,%esp
}
8010488a:	c9                   	leave  
8010488b:	c3                   	ret    
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104895:	c9                   	leave  
80104896:	c3                   	ret    
80104897:	89 f6                	mov    %esi,%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801048a5:	e8 56 ef ff ff       	call   80103800 <myproc>

  num = curproc->tf->eax;
801048aa:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801048ad:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801048af:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048b2:	8d 50 ff             	lea    -0x1(%eax),%edx
801048b5:	83 fa 14             	cmp    $0x14,%edx
801048b8:	77 1e                	ja     801048d8 <syscall+0x38>
801048ba:	8b 14 85 40 76 10 80 	mov    -0x7fef89c0(,%eax,4),%edx
801048c1:	85 d2                	test   %edx,%edx
801048c3:	74 13                	je     801048d8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048c5:	ff d2                	call   *%edx
801048c7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048cd:	5b                   	pop    %ebx
801048ce:	5e                   	pop    %esi
801048cf:	5d                   	pop    %ebp
801048d0:	c3                   	ret    
801048d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048d8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801048d9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048dc:	50                   	push   %eax
801048dd:	ff 73 10             	pushl  0x10(%ebx)
801048e0:	68 11 76 10 80       	push   $0x80107611
801048e5:	e8 76 bd ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801048ea:	8b 43 18             	mov    0x18(%ebx),%eax
801048ed:	83 c4 10             	add    $0x10,%esp
801048f0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801048f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048fa:	5b                   	pop    %ebx
801048fb:	5e                   	pop    %esi
801048fc:	5d                   	pop    %ebp
801048fd:	c3                   	ret    
801048fe:	66 90                	xchg   %ax,%ax

80104900 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	56                   	push   %esi
80104905:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104906:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104909:	83 ec 44             	sub    $0x44,%esp
8010490c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010490f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104912:	56                   	push   %esi
80104913:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104914:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104917:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010491a:	e8 41 d6 ff ff       	call   80101f60 <nameiparent>
8010491f:	83 c4 10             	add    $0x10,%esp
80104922:	85 c0                	test   %eax,%eax
80104924:	0f 84 f6 00 00 00    	je     80104a20 <create+0x120>
    return 0;
  ilock(dp);
8010492a:	83 ec 0c             	sub    $0xc,%esp
8010492d:	89 c7                	mov    %eax,%edi
8010492f:	50                   	push   %eax
80104930:	e8 7b cd ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104935:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104938:	83 c4 0c             	add    $0xc,%esp
8010493b:	50                   	push   %eax
8010493c:	56                   	push   %esi
8010493d:	57                   	push   %edi
8010493e:	e8 dd d2 ff ff       	call   80101c20 <dirlookup>
80104943:	83 c4 10             	add    $0x10,%esp
80104946:	85 c0                	test   %eax,%eax
80104948:	89 c3                	mov    %eax,%ebx
8010494a:	74 54                	je     801049a0 <create+0xa0>
    iunlockput(dp);
8010494c:	83 ec 0c             	sub    $0xc,%esp
8010494f:	57                   	push   %edi
80104950:	e8 0b d0 ff ff       	call   80101960 <iunlockput>
    ilock(ip);
80104955:	89 1c 24             	mov    %ebx,(%esp)
80104958:	e8 53 cd ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010495d:	83 c4 10             	add    $0x10,%esp
80104960:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104965:	75 19                	jne    80104980 <create+0x80>
80104967:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010496c:	89 d8                	mov    %ebx,%eax
8010496e:	75 10                	jne    80104980 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104973:	5b                   	pop    %ebx
80104974:	5e                   	pop    %esi
80104975:	5f                   	pop    %edi
80104976:	5d                   	pop    %ebp
80104977:	c3                   	ret    
80104978:	90                   	nop
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104980:	83 ec 0c             	sub    $0xc,%esp
80104983:	53                   	push   %ebx
80104984:	e8 d7 cf ff ff       	call   80101960 <iunlockput>
    return 0;
80104989:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010498c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010498f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104991:	5b                   	pop    %ebx
80104992:	5e                   	pop    %esi
80104993:	5f                   	pop    %edi
80104994:	5d                   	pop    %ebp
80104995:	c3                   	ret    
80104996:	8d 76 00             	lea    0x0(%esi),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801049a0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801049a4:	83 ec 08             	sub    $0x8,%esp
801049a7:	50                   	push   %eax
801049a8:	ff 37                	pushl  (%edi)
801049aa:	e8 51 cb ff ff       	call   80101500 <ialloc>
801049af:	83 c4 10             	add    $0x10,%esp
801049b2:	85 c0                	test   %eax,%eax
801049b4:	89 c3                	mov    %eax,%ebx
801049b6:	0f 84 cc 00 00 00    	je     80104a88 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801049bc:	83 ec 0c             	sub    $0xc,%esp
801049bf:	50                   	push   %eax
801049c0:	e8 eb cc ff ff       	call   801016b0 <ilock>
  ip->major = major;
801049c5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049c9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801049cd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049d1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801049d5:	b8 01 00 00 00       	mov    $0x1,%eax
801049da:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801049de:	89 1c 24             	mov    %ebx,(%esp)
801049e1:	e8 fa cb ff ff       	call   801015e0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801049e6:	83 c4 10             	add    $0x10,%esp
801049e9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049ee:	74 40                	je     80104a30 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801049f0:	83 ec 04             	sub    $0x4,%esp
801049f3:	ff 73 04             	pushl  0x4(%ebx)
801049f6:	56                   	push   %esi
801049f7:	57                   	push   %edi
801049f8:	e8 83 d4 ff ff       	call   80101e80 <dirlink>
801049fd:	83 c4 10             	add    $0x10,%esp
80104a00:	85 c0                	test   %eax,%eax
80104a02:	78 77                	js     80104a7b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104a04:	83 ec 0c             	sub    $0xc,%esp
80104a07:	57                   	push   %edi
80104a08:	e8 53 cf ff ff       	call   80101960 <iunlockput>

  return ip;
80104a0d:	83 c4 10             	add    $0x10,%esp
}
80104a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a13:	89 d8                	mov    %ebx,%eax
}
80104a15:	5b                   	pop    %ebx
80104a16:	5e                   	pop    %esi
80104a17:	5f                   	pop    %edi
80104a18:	5d                   	pop    %ebp
80104a19:	c3                   	ret    
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a20:	31 c0                	xor    %eax,%eax
80104a22:	e9 49 ff ff ff       	jmp    80104970 <create+0x70>
80104a27:	89 f6                	mov    %esi,%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a30:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a35:	83 ec 0c             	sub    $0xc,%esp
80104a38:	57                   	push   %edi
80104a39:	e8 a2 cb ff ff       	call   801015e0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a3e:	83 c4 0c             	add    $0xc,%esp
80104a41:	ff 73 04             	pushl  0x4(%ebx)
80104a44:	68 b4 76 10 80       	push   $0x801076b4
80104a49:	53                   	push   %ebx
80104a4a:	e8 31 d4 ff ff       	call   80101e80 <dirlink>
80104a4f:	83 c4 10             	add    $0x10,%esp
80104a52:	85 c0                	test   %eax,%eax
80104a54:	78 18                	js     80104a6e <create+0x16e>
80104a56:	83 ec 04             	sub    $0x4,%esp
80104a59:	ff 77 04             	pushl  0x4(%edi)
80104a5c:	68 b3 76 10 80       	push   $0x801076b3
80104a61:	53                   	push   %ebx
80104a62:	e8 19 d4 ff ff       	call   80101e80 <dirlink>
80104a67:	83 c4 10             	add    $0x10,%esp
80104a6a:	85 c0                	test   %eax,%eax
80104a6c:	79 82                	jns    801049f0 <create+0xf0>
      panic("create dots");
80104a6e:	83 ec 0c             	sub    $0xc,%esp
80104a71:	68 a7 76 10 80       	push   $0x801076a7
80104a76:	e8 f5 b8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a7b:	83 ec 0c             	sub    $0xc,%esp
80104a7e:	68 b6 76 10 80       	push   $0x801076b6
80104a83:	e8 e8 b8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104a88:	83 ec 0c             	sub    $0xc,%esp
80104a8b:	68 98 76 10 80       	push   $0x80107698
80104a90:	e8 db b8 ff ff       	call   80100370 <panic>
80104a95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
80104aa5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104aa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104aaa:	89 d3                	mov    %edx,%ebx
80104aac:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104aaf:	50                   	push   %eax
80104ab0:	6a 00                	push   $0x0
80104ab2:	e8 f9 fc ff ff       	call   801047b0 <argint>
80104ab7:	83 c4 10             	add    $0x10,%esp
80104aba:	85 c0                	test   %eax,%eax
80104abc:	78 32                	js     80104af0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104abe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ac2:	77 2c                	ja     80104af0 <argfd.constprop.0+0x50>
80104ac4:	e8 37 ed ff ff       	call   80103800 <myproc>
80104ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104acc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	74 1c                	je     80104af0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104ad4:	85 f6                	test   %esi,%esi
80104ad6:	74 02                	je     80104ada <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ad8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104ada:	85 db                	test   %ebx,%ebx
80104adc:	74 22                	je     80104b00 <argfd.constprop.0+0x60>
    *pf = f;
80104ade:	89 03                	mov    %eax,(%ebx)
  return 0;
80104ae0:	31 c0                	xor    %eax,%eax
}
80104ae2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae5:	5b                   	pop    %ebx
80104ae6:	5e                   	pop    %esi
80104ae7:	5d                   	pop    %ebp
80104ae8:	c3                   	ret    
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104af8:	5b                   	pop    %ebx
80104af9:	5e                   	pop    %esi
80104afa:	5d                   	pop    %ebp
80104afb:	c3                   	ret    
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b00:	31 c0                	xor    %eax,%eax
80104b02:	eb de                	jmp    80104ae2 <argfd.constprop.0+0x42>
80104b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b10 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b10:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b11:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	56                   	push   %esi
80104b16:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b17:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104b1a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b1d:	e8 7e ff ff ff       	call   80104aa0 <argfd.constprop.0>
80104b22:	85 c0                	test   %eax,%eax
80104b24:	78 1a                	js     80104b40 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b26:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b28:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104b2b:	e8 d0 ec ff ff       	call   80103800 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104b30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104b34:	85 d2                	test   %edx,%edx
80104b36:	74 18                	je     80104b50 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b38:	83 c3 01             	add    $0x1,%ebx
80104b3b:	83 fb 10             	cmp    $0x10,%ebx
80104b3e:	75 f0                	jne    80104b30 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b40:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b48:	5b                   	pop    %ebx
80104b49:	5e                   	pop    %esi
80104b4a:	5d                   	pop    %ebp
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104b50:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b54:	83 ec 0c             	sub    $0xc,%esp
80104b57:	ff 75 f4             	pushl  -0xc(%ebp)
80104b5a:	e8 81 c2 ff ff       	call   80100de0 <filedup>
  return fd;
80104b5f:	83 c4 10             	add    $0x10,%esp
}
80104b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104b65:	89 d8                	mov    %ebx,%eax
}
80104b67:	5b                   	pop    %ebx
80104b68:	5e                   	pop    %esi
80104b69:	5d                   	pop    %ebp
80104b6a:	c3                   	ret    
80104b6b:	90                   	nop
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <sys_read>:

int
sys_read(void)
{
80104b70:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b71:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b7b:	e8 20 ff ff ff       	call   80104aa0 <argfd.constprop.0>
80104b80:	85 c0                	test   %eax,%eax
80104b82:	78 4c                	js     80104bd0 <sys_read+0x60>
80104b84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b87:	83 ec 08             	sub    $0x8,%esp
80104b8a:	50                   	push   %eax
80104b8b:	6a 02                	push   $0x2
80104b8d:	e8 1e fc ff ff       	call   801047b0 <argint>
80104b92:	83 c4 10             	add    $0x10,%esp
80104b95:	85 c0                	test   %eax,%eax
80104b97:	78 37                	js     80104bd0 <sys_read+0x60>
80104b99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b9c:	83 ec 04             	sub    $0x4,%esp
80104b9f:	ff 75 f0             	pushl  -0x10(%ebp)
80104ba2:	50                   	push   %eax
80104ba3:	6a 01                	push   $0x1
80104ba5:	e8 56 fc ff ff       	call   80104800 <argptr>
80104baa:	83 c4 10             	add    $0x10,%esp
80104bad:	85 c0                	test   %eax,%eax
80104baf:	78 1f                	js     80104bd0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104bb1:	83 ec 04             	sub    $0x4,%esp
80104bb4:	ff 75 f0             	pushl  -0x10(%ebp)
80104bb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bba:	ff 75 ec             	pushl  -0x14(%ebp)
80104bbd:	e8 8e c3 ff ff       	call   80100f50 <fileread>
80104bc2:	83 c4 10             	add    $0x10,%esp
}
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_write>:

int
sys_write(void)
{
80104be0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104beb:	e8 b0 fe ff ff       	call   80104aa0 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 4c                	js     80104c40 <sys_write+0x60>
80104bf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bf7:	83 ec 08             	sub    $0x8,%esp
80104bfa:	50                   	push   %eax
80104bfb:	6a 02                	push   $0x2
80104bfd:	e8 ae fb ff ff       	call   801047b0 <argint>
80104c02:	83 c4 10             	add    $0x10,%esp
80104c05:	85 c0                	test   %eax,%eax
80104c07:	78 37                	js     80104c40 <sys_write+0x60>
80104c09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c0c:	83 ec 04             	sub    $0x4,%esp
80104c0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c12:	50                   	push   %eax
80104c13:	6a 01                	push   $0x1
80104c15:	e8 e6 fb ff ff       	call   80104800 <argptr>
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	85 c0                	test   %eax,%eax
80104c1f:	78 1f                	js     80104c40 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c21:	83 ec 04             	sub    $0x4,%esp
80104c24:	ff 75 f0             	pushl  -0x10(%ebp)
80104c27:	ff 75 f4             	pushl  -0xc(%ebp)
80104c2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c2d:	e8 ae c3 ff ff       	call   80100fe0 <filewrite>
80104c32:	83 c4 10             	add    $0x10,%esp
}
80104c35:	c9                   	leave  
80104c36:	c3                   	ret    
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <sys_close>:

int
sys_close(void)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c5c:	e8 3f fe ff ff       	call   80104aa0 <argfd.constprop.0>
80104c61:	85 c0                	test   %eax,%eax
80104c63:	78 2b                	js     80104c90 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104c65:	e8 96 eb ff ff       	call   80103800 <myproc>
80104c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c6d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104c70:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c77:	00 
  fileclose(f);
80104c78:	ff 75 f4             	pushl  -0xc(%ebp)
80104c7b:	e8 b0 c1 ff ff       	call   80100e30 <fileclose>
  return 0;
80104c80:	83 c4 10             	add    $0x10,%esp
80104c83:	31 c0                	xor    %eax,%eax
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104c95:	c9                   	leave  
80104c96:	c3                   	ret    
80104c97:	89 f6                	mov    %esi,%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <sys_fstat>:

int
sys_fstat(void)
{
80104ca0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ca1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104ca3:	89 e5                	mov    %esp,%ebp
80104ca5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ca8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104cab:	e8 f0 fd ff ff       	call   80104aa0 <argfd.constprop.0>
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	78 2c                	js     80104ce0 <sys_fstat+0x40>
80104cb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cb7:	83 ec 04             	sub    $0x4,%esp
80104cba:	6a 1c                	push   $0x1c
80104cbc:	50                   	push   %eax
80104cbd:	6a 01                	push   $0x1
80104cbf:	e8 3c fb ff ff       	call   80104800 <argptr>
80104cc4:	83 c4 10             	add    $0x10,%esp
80104cc7:	85 c0                	test   %eax,%eax
80104cc9:	78 15                	js     80104ce0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104ccb:	83 ec 08             	sub    $0x8,%esp
80104cce:	ff 75 f4             	pushl  -0xc(%ebp)
80104cd1:	ff 75 f0             	pushl  -0x10(%ebp)
80104cd4:	e8 27 c2 ff ff       	call   80100f00 <filestat>
80104cd9:	83 c4 10             	add    $0x10,%esp
}
80104cdc:	c9                   	leave  
80104cdd:	c3                   	ret    
80104cde:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cf6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104cf9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cfc:	50                   	push   %eax
80104cfd:	6a 00                	push   $0x0
80104cff:	e8 5c fb ff ff       	call   80104860 <argstr>
80104d04:	83 c4 10             	add    $0x10,%esp
80104d07:	85 c0                	test   %eax,%eax
80104d09:	0f 88 fb 00 00 00    	js     80104e0a <sys_link+0x11a>
80104d0f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d12:	83 ec 08             	sub    $0x8,%esp
80104d15:	50                   	push   %eax
80104d16:	6a 01                	push   $0x1
80104d18:	e8 43 fb ff ff       	call   80104860 <argstr>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	85 c0                	test   %eax,%eax
80104d22:	0f 88 e2 00 00 00    	js     80104e0a <sys_link+0x11a>
    return -1;

  begin_op();
80104d28:	e8 a3 de ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
80104d2d:	83 ec 0c             	sub    $0xc,%esp
80104d30:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d33:	e8 08 d2 ff ff       	call   80101f40 <namei>
80104d38:	83 c4 10             	add    $0x10,%esp
80104d3b:	85 c0                	test   %eax,%eax
80104d3d:	89 c3                	mov    %eax,%ebx
80104d3f:	0f 84 f3 00 00 00    	je     80104e38 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d45:	83 ec 0c             	sub    $0xc,%esp
80104d48:	50                   	push   %eax
80104d49:	e8 62 c9 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104d4e:	83 c4 10             	add    $0x10,%esp
80104d51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d56:	0f 84 c4 00 00 00    	je     80104e20 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d5c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d61:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d64:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d67:	53                   	push   %ebx
80104d68:	e8 73 c8 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104d6d:	89 1c 24             	mov    %ebx,(%esp)
80104d70:	e8 3b ca ff ff       	call   801017b0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d75:	58                   	pop    %eax
80104d76:	5a                   	pop    %edx
80104d77:	57                   	push   %edi
80104d78:	ff 75 d0             	pushl  -0x30(%ebp)
80104d7b:	e8 e0 d1 ff ff       	call   80101f60 <nameiparent>
80104d80:	83 c4 10             	add    $0x10,%esp
80104d83:	85 c0                	test   %eax,%eax
80104d85:	89 c6                	mov    %eax,%esi
80104d87:	74 5b                	je     80104de4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	50                   	push   %eax
80104d8d:	e8 1e c9 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d92:	83 c4 10             	add    $0x10,%esp
80104d95:	8b 03                	mov    (%ebx),%eax
80104d97:	39 06                	cmp    %eax,(%esi)
80104d99:	75 3d                	jne    80104dd8 <sys_link+0xe8>
80104d9b:	83 ec 04             	sub    $0x4,%esp
80104d9e:	ff 73 04             	pushl  0x4(%ebx)
80104da1:	57                   	push   %edi
80104da2:	56                   	push   %esi
80104da3:	e8 d8 d0 ff ff       	call   80101e80 <dirlink>
80104da8:	83 c4 10             	add    $0x10,%esp
80104dab:	85 c0                	test   %eax,%eax
80104dad:	78 29                	js     80104dd8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	56                   	push   %esi
80104db3:	e8 a8 cb ff ff       	call   80101960 <iunlockput>
  iput(ip);
80104db8:	89 1c 24             	mov    %ebx,(%esp)
80104dbb:	e8 40 ca ff ff       	call   80101800 <iput>

  end_op();
80104dc0:	e8 7b de ff ff       	call   80102c40 <end_op>

  return 0;
80104dc5:	83 c4 10             	add    $0x10,%esp
80104dc8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dcd:	5b                   	pop    %ebx
80104dce:	5e                   	pop    %esi
80104dcf:	5f                   	pop    %edi
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret    
80104dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	56                   	push   %esi
80104ddc:	e8 7f cb ff ff       	call   80101960 <iunlockput>
    goto bad;
80104de1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	53                   	push   %ebx
80104de8:	e8 c3 c8 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80104ded:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104df2:	89 1c 24             	mov    %ebx,(%esp)
80104df5:	e8 e6 c7 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104dfa:	89 1c 24             	mov    %ebx,(%esp)
80104dfd:	e8 5e cb ff ff       	call   80101960 <iunlockput>
  end_op();
80104e02:	e8 39 de ff ff       	call   80102c40 <end_op>
  return -1;
80104e07:	83 c4 10             	add    $0x10,%esp
}
80104e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e12:	5b                   	pop    %ebx
80104e13:	5e                   	pop    %esi
80104e14:	5f                   	pop    %edi
80104e15:	5d                   	pop    %ebp
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e20:	83 ec 0c             	sub    $0xc,%esp
80104e23:	53                   	push   %ebx
80104e24:	e8 37 cb ff ff       	call   80101960 <iunlockput>
    end_op();
80104e29:	e8 12 de ff ff       	call   80102c40 <end_op>
    return -1;
80104e2e:	83 c4 10             	add    $0x10,%esp
80104e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e36:	eb 92                	jmp    80104dca <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e38:	e8 03 de ff ff       	call   80102c40 <end_op>
    return -1;
80104e3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e42:	eb 86                	jmp    80104dca <sys_link+0xda>
80104e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e50 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	56                   	push   %esi
80104e55:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e56:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e59:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e5c:	50                   	push   %eax
80104e5d:	6a 00                	push   $0x0
80104e5f:	e8 fc f9 ff ff       	call   80104860 <argstr>
80104e64:	83 c4 10             	add    $0x10,%esp
80104e67:	85 c0                	test   %eax,%eax
80104e69:	0f 88 82 01 00 00    	js     80104ff1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e6f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104e72:	e8 59 dd ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e77:	83 ec 08             	sub    $0x8,%esp
80104e7a:	53                   	push   %ebx
80104e7b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e7e:	e8 dd d0 ff ff       	call   80101f60 <nameiparent>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e8b:	0f 84 6a 01 00 00    	je     80104ffb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104e91:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	56                   	push   %esi
80104e98:	e8 13 c8 ff ff       	call   801016b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e9d:	58                   	pop    %eax
80104e9e:	5a                   	pop    %edx
80104e9f:	68 b4 76 10 80       	push   $0x801076b4
80104ea4:	53                   	push   %ebx
80104ea5:	e8 56 cd ff ff       	call   80101c00 <namecmp>
80104eaa:	83 c4 10             	add    $0x10,%esp
80104ead:	85 c0                	test   %eax,%eax
80104eaf:	0f 84 fc 00 00 00    	je     80104fb1 <sys_unlink+0x161>
80104eb5:	83 ec 08             	sub    $0x8,%esp
80104eb8:	68 b3 76 10 80       	push   $0x801076b3
80104ebd:	53                   	push   %ebx
80104ebe:	e8 3d cd ff ff       	call   80101c00 <namecmp>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	0f 84 e3 00 00 00    	je     80104fb1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104ece:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ed1:	83 ec 04             	sub    $0x4,%esp
80104ed4:	50                   	push   %eax
80104ed5:	53                   	push   %ebx
80104ed6:	56                   	push   %esi
80104ed7:	e8 44 cd ff ff       	call   80101c20 <dirlookup>
80104edc:	83 c4 10             	add    $0x10,%esp
80104edf:	85 c0                	test   %eax,%eax
80104ee1:	89 c3                	mov    %eax,%ebx
80104ee3:	0f 84 c8 00 00 00    	je     80104fb1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104ee9:	83 ec 0c             	sub    $0xc,%esp
80104eec:	50                   	push   %eax
80104eed:	e8 be c7 ff ff       	call   801016b0 <ilock>

  if(ip->nlink < 1)
80104ef2:	83 c4 10             	add    $0x10,%esp
80104ef5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104efa:	0f 8e 24 01 00 00    	jle    80105024 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f00:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f05:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104f08:	74 66                	je     80104f70 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104f0a:	83 ec 04             	sub    $0x4,%esp
80104f0d:	6a 10                	push   $0x10
80104f0f:	6a 00                	push   $0x0
80104f11:	56                   	push   %esi
80104f12:	e8 89 f5 ff ff       	call   801044a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f17:	6a 10                	push   $0x10
80104f19:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f1c:	56                   	push   %esi
80104f1d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f20:	e8 ab cb ff ff       	call   80101ad0 <writei>
80104f25:	83 c4 20             	add    $0x20,%esp
80104f28:	83 f8 10             	cmp    $0x10,%eax
80104f2b:	0f 85 e6 00 00 00    	jne    80105017 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f36:	0f 84 9c 00 00 00    	je     80104fd8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f3c:	83 ec 0c             	sub    $0xc,%esp
80104f3f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f42:	e8 19 ca ff ff       	call   80101960 <iunlockput>

  ip->nlink--;
80104f47:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f4c:	89 1c 24             	mov    %ebx,(%esp)
80104f4f:	e8 8c c6 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104f54:	89 1c 24             	mov    %ebx,(%esp)
80104f57:	e8 04 ca ff ff       	call   80101960 <iunlockput>

  end_op();
80104f5c:	e8 df dc ff ff       	call   80102c40 <end_op>

  return 0;
80104f61:	83 c4 10             	add    $0x10,%esp
80104f64:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f69:	5b                   	pop    %ebx
80104f6a:	5e                   	pop    %esi
80104f6b:	5f                   	pop    %edi
80104f6c:	5d                   	pop    %ebp
80104f6d:	c3                   	ret    
80104f6e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f70:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f74:	76 94                	jbe    80104f0a <sys_unlink+0xba>
80104f76:	bf 20 00 00 00       	mov    $0x20,%edi
80104f7b:	eb 0f                	jmp    80104f8c <sys_unlink+0x13c>
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
80104f80:	83 c7 10             	add    $0x10,%edi
80104f83:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104f86:	0f 83 7e ff ff ff    	jae    80104f0a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f8c:	6a 10                	push   $0x10
80104f8e:	57                   	push   %edi
80104f8f:	56                   	push   %esi
80104f90:	53                   	push   %ebx
80104f91:	e8 3a ca ff ff       	call   801019d0 <readi>
80104f96:	83 c4 10             	add    $0x10,%esp
80104f99:	83 f8 10             	cmp    $0x10,%eax
80104f9c:	75 6c                	jne    8010500a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104f9e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104fa3:	74 db                	je     80104f80 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104fa5:	83 ec 0c             	sub    $0xc,%esp
80104fa8:	53                   	push   %ebx
80104fa9:	e8 b2 c9 ff ff       	call   80101960 <iunlockput>
    goto bad;
80104fae:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104fb1:	83 ec 0c             	sub    $0xc,%esp
80104fb4:	ff 75 b4             	pushl  -0x4c(%ebp)
80104fb7:	e8 a4 c9 ff ff       	call   80101960 <iunlockput>
  end_op();
80104fbc:	e8 7f dc ff ff       	call   80102c40 <end_op>
  return -1;
80104fc1:	83 c4 10             	add    $0x10,%esp
}
80104fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fcc:	5b                   	pop    %ebx
80104fcd:	5e                   	pop    %esi
80104fce:	5f                   	pop    %edi
80104fcf:	5d                   	pop    %ebp
80104fd0:	c3                   	ret    
80104fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fd8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104fdb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fde:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104fe3:	50                   	push   %eax
80104fe4:	e8 f7 c5 ff ff       	call   801015e0 <iupdate>
80104fe9:	83 c4 10             	add    $0x10,%esp
80104fec:	e9 4b ff ff ff       	jmp    80104f3c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ff6:	e9 6b ff ff ff       	jmp    80104f66 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104ffb:	e8 40 dc ff ff       	call   80102c40 <end_op>
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105005:	e9 5c ff ff ff       	jmp    80104f66 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010500a:	83 ec 0c             	sub    $0xc,%esp
8010500d:	68 d8 76 10 80       	push   $0x801076d8
80105012:	e8 59 b3 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105017:	83 ec 0c             	sub    $0xc,%esp
8010501a:	68 ea 76 10 80       	push   $0x801076ea
8010501f:	e8 4c b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	68 c6 76 10 80       	push   $0x801076c6
8010502c:	e8 3f b3 ff ff       	call   80100370 <panic>
80105031:	eb 0d                	jmp    80105040 <sys_open>
80105033:	90                   	nop
80105034:	90                   	nop
80105035:	90                   	nop
80105036:	90                   	nop
80105037:	90                   	nop
80105038:	90                   	nop
80105039:	90                   	nop
8010503a:	90                   	nop
8010503b:	90                   	nop
8010503c:	90                   	nop
8010503d:	90                   	nop
8010503e:	90                   	nop
8010503f:	90                   	nop

80105040 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105049:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010504c:	50                   	push   %eax
8010504d:	6a 00                	push   $0x0
8010504f:	e8 0c f8 ff ff       	call   80104860 <argstr>
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	85 c0                	test   %eax,%eax
80105059:	0f 88 9e 00 00 00    	js     801050fd <sys_open+0xbd>
8010505f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105062:	83 ec 08             	sub    $0x8,%esp
80105065:	50                   	push   %eax
80105066:	6a 01                	push   $0x1
80105068:	e8 43 f7 ff ff       	call   801047b0 <argint>
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	85 c0                	test   %eax,%eax
80105072:	0f 88 85 00 00 00    	js     801050fd <sys_open+0xbd>
    return -1;

  begin_op();
80105078:	e8 53 db ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
8010507d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105081:	0f 85 89 00 00 00    	jne    80105110 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105087:	83 ec 0c             	sub    $0xc,%esp
8010508a:	ff 75 e0             	pushl  -0x20(%ebp)
8010508d:	e8 ae ce ff ff       	call   80101f40 <namei>
80105092:	83 c4 10             	add    $0x10,%esp
80105095:	85 c0                	test   %eax,%eax
80105097:	89 c6                	mov    %eax,%esi
80105099:	0f 84 8e 00 00 00    	je     8010512d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010509f:	83 ec 0c             	sub    $0xc,%esp
801050a2:	50                   	push   %eax
801050a3:	e8 08 c6 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801050a8:	83 c4 10             	add    $0x10,%esp
801050ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801050b0:	0f 84 d2 00 00 00    	je     80105188 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801050b6:	e8 b5 bc ff ff       	call   80100d70 <filealloc>
801050bb:	85 c0                	test   %eax,%eax
801050bd:	89 c7                	mov    %eax,%edi
801050bf:	74 2b                	je     801050ec <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050c1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801050c3:	e8 38 e7 ff ff       	call   80103800 <myproc>
801050c8:	90                   	nop
801050c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801050d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050d4:	85 d2                	test   %edx,%edx
801050d6:	74 68                	je     80105140 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050d8:	83 c3 01             	add    $0x1,%ebx
801050db:	83 fb 10             	cmp    $0x10,%ebx
801050de:	75 f0                	jne    801050d0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	57                   	push   %edi
801050e4:	e8 47 bd ff ff       	call   80100e30 <fileclose>
801050e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801050ec:	83 ec 0c             	sub    $0xc,%esp
801050ef:	56                   	push   %esi
801050f0:	e8 6b c8 ff ff       	call   80101960 <iunlockput>
    end_op();
801050f5:	e8 46 db ff ff       	call   80102c40 <end_op>
    return -1;
801050fa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105105:	5b                   	pop    %ebx
80105106:	5e                   	pop    %esi
80105107:	5f                   	pop    %edi
80105108:	5d                   	pop    %ebp
80105109:	c3                   	ret    
8010510a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105116:	31 c9                	xor    %ecx,%ecx
80105118:	6a 00                	push   $0x0
8010511a:	ba 02 00 00 00       	mov    $0x2,%edx
8010511f:	e8 dc f7 ff ff       	call   80104900 <create>
    if(ip == 0){
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105129:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010512b:	75 89                	jne    801050b6 <sys_open+0x76>
      end_op();
8010512d:	e8 0e db ff ff       	call   80102c40 <end_op>
      return -1;
80105132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105137:	eb 43                	jmp    8010517c <sys_open+0x13c>
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105140:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105143:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105147:	56                   	push   %esi
80105148:	e8 63 c6 ff ff       	call   801017b0 <iunlock>
  end_op();
8010514d:	e8 ee da ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80105152:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105158:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010515b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010515e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105161:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105168:	89 d0                	mov    %edx,%eax
8010516a:	83 e0 01             	and    $0x1,%eax
8010516d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105170:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105173:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105176:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010517a:	89 d8                	mov    %ebx,%eax
}
8010517c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010517f:	5b                   	pop    %ebx
80105180:	5e                   	pop    %esi
80105181:	5f                   	pop    %edi
80105182:	5d                   	pop    %ebp
80105183:	c3                   	ret    
80105184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105188:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010518b:	85 c9                	test   %ecx,%ecx
8010518d:	0f 84 23 ff ff ff    	je     801050b6 <sys_open+0x76>
80105193:	e9 54 ff ff ff       	jmp    801050ec <sys_open+0xac>
80105198:	90                   	nop
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051a0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051a6:	e8 25 da ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ae:	83 ec 08             	sub    $0x8,%esp
801051b1:	50                   	push   %eax
801051b2:	6a 00                	push   $0x0
801051b4:	e8 a7 f6 ff ff       	call   80104860 <argstr>
801051b9:	83 c4 10             	add    $0x10,%esp
801051bc:	85 c0                	test   %eax,%eax
801051be:	78 30                	js     801051f0 <sys_mkdir+0x50>
801051c0:	83 ec 0c             	sub    $0xc,%esp
801051c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051c6:	31 c9                	xor    %ecx,%ecx
801051c8:	6a 00                	push   $0x0
801051ca:	ba 01 00 00 00       	mov    $0x1,%edx
801051cf:	e8 2c f7 ff ff       	call   80104900 <create>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	74 15                	je     801051f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051db:	83 ec 0c             	sub    $0xc,%esp
801051de:	50                   	push   %eax
801051df:	e8 7c c7 ff ff       	call   80101960 <iunlockput>
  end_op();
801051e4:	e8 57 da ff ff       	call   80102c40 <end_op>
  return 0;
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	31 c0                	xor    %eax,%eax
}
801051ee:	c9                   	leave  
801051ef:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801051f0:	e8 4b da ff ff       	call   80102c40 <end_op>
    return -1;
801051f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801051fa:	c9                   	leave  
801051fb:	c3                   	ret    
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105200 <sys_mknod>:

int
sys_mknod(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105206:	e8 c5 d9 ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010520b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010520e:	83 ec 08             	sub    $0x8,%esp
80105211:	50                   	push   %eax
80105212:	6a 00                	push   $0x0
80105214:	e8 47 f6 ff ff       	call   80104860 <argstr>
80105219:	83 c4 10             	add    $0x10,%esp
8010521c:	85 c0                	test   %eax,%eax
8010521e:	78 60                	js     80105280 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105220:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105223:	83 ec 08             	sub    $0x8,%esp
80105226:	50                   	push   %eax
80105227:	6a 01                	push   $0x1
80105229:	e8 82 f5 ff ff       	call   801047b0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	85 c0                	test   %eax,%eax
80105233:	78 4b                	js     80105280 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105235:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105238:	83 ec 08             	sub    $0x8,%esp
8010523b:	50                   	push   %eax
8010523c:	6a 02                	push   $0x2
8010523e:	e8 6d f5 ff ff       	call   801047b0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	78 36                	js     80105280 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010524a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010524e:	83 ec 0c             	sub    $0xc,%esp
80105251:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105255:	ba 03 00 00 00       	mov    $0x3,%edx
8010525a:	50                   	push   %eax
8010525b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010525e:	e8 9d f6 ff ff       	call   80104900 <create>
80105263:	83 c4 10             	add    $0x10,%esp
80105266:	85 c0                	test   %eax,%eax
80105268:	74 16                	je     80105280 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010526a:	83 ec 0c             	sub    $0xc,%esp
8010526d:	50                   	push   %eax
8010526e:	e8 ed c6 ff ff       	call   80101960 <iunlockput>
  end_op();
80105273:	e8 c8 d9 ff ff       	call   80102c40 <end_op>
  return 0;
80105278:	83 c4 10             	add    $0x10,%esp
8010527b:	31 c0                	xor    %eax,%eax
}
8010527d:	c9                   	leave  
8010527e:	c3                   	ret    
8010527f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105280:	e8 bb d9 ff ff       	call   80102c40 <end_op>
    return -1;
80105285:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010528a:	c9                   	leave  
8010528b:	c3                   	ret    
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_chdir>:

int
sys_chdir(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	56                   	push   %esi
80105294:	53                   	push   %ebx
80105295:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105298:	e8 63 e5 ff ff       	call   80103800 <myproc>
8010529d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010529f:	e8 2c d9 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a7:	83 ec 08             	sub    $0x8,%esp
801052aa:	50                   	push   %eax
801052ab:	6a 00                	push   $0x0
801052ad:	e8 ae f5 ff ff       	call   80104860 <argstr>
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	85 c0                	test   %eax,%eax
801052b7:	78 77                	js     80105330 <sys_chdir+0xa0>
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	ff 75 f4             	pushl  -0xc(%ebp)
801052bf:	e8 7c cc ff ff       	call   80101f40 <namei>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	89 c3                	mov    %eax,%ebx
801052cb:	74 63                	je     80105330 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052cd:	83 ec 0c             	sub    $0xc,%esp
801052d0:	50                   	push   %eax
801052d1:	e8 da c3 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
801052d6:	83 c4 10             	add    $0x10,%esp
801052d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052de:	75 30                	jne    80105310 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	53                   	push   %ebx
801052e4:	e8 c7 c4 ff ff       	call   801017b0 <iunlock>
  iput(curproc->cwd);
801052e9:	58                   	pop    %eax
801052ea:	ff 76 68             	pushl  0x68(%esi)
801052ed:	e8 0e c5 ff ff       	call   80101800 <iput>
  end_op();
801052f2:	e8 49 d9 ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
801052f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801052fa:	83 c4 10             	add    $0x10,%esp
801052fd:	31 c0                	xor    %eax,%eax
}
801052ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105302:	5b                   	pop    %ebx
80105303:	5e                   	pop    %esi
80105304:	5d                   	pop    %ebp
80105305:	c3                   	ret    
80105306:	8d 76 00             	lea    0x0(%esi),%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105310:	83 ec 0c             	sub    $0xc,%esp
80105313:	53                   	push   %ebx
80105314:	e8 47 c6 ff ff       	call   80101960 <iunlockput>
    end_op();
80105319:	e8 22 d9 ff ff       	call   80102c40 <end_op>
    return -1;
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105326:	eb d7                	jmp    801052ff <sys_chdir+0x6f>
80105328:	90                   	nop
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105330:	e8 0b d9 ff ff       	call   80102c40 <end_op>
    return -1;
80105335:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533a:	eb c3                	jmp    801052ff <sys_chdir+0x6f>
8010533c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105340 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
80105345:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105346:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010534c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105352:	50                   	push   %eax
80105353:	6a 00                	push   $0x0
80105355:	e8 06 f5 ff ff       	call   80104860 <argstr>
8010535a:	83 c4 10             	add    $0x10,%esp
8010535d:	85 c0                	test   %eax,%eax
8010535f:	78 7f                	js     801053e0 <sys_exec+0xa0>
80105361:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105367:	83 ec 08             	sub    $0x8,%esp
8010536a:	50                   	push   %eax
8010536b:	6a 01                	push   $0x1
8010536d:	e8 3e f4 ff ff       	call   801047b0 <argint>
80105372:	83 c4 10             	add    $0x10,%esp
80105375:	85 c0                	test   %eax,%eax
80105377:	78 67                	js     801053e0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105379:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010537f:	83 ec 04             	sub    $0x4,%esp
80105382:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105388:	68 80 00 00 00       	push   $0x80
8010538d:	6a 00                	push   $0x0
8010538f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105395:	50                   	push   %eax
80105396:	31 db                	xor    %ebx,%ebx
80105398:	e8 03 f1 ff ff       	call   801044a0 <memset>
8010539d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053a6:	83 ec 08             	sub    $0x8,%esp
801053a9:	57                   	push   %edi
801053aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801053ad:	50                   	push   %eax
801053ae:	e8 5d f3 ff ff       	call   80104710 <fetchint>
801053b3:	83 c4 10             	add    $0x10,%esp
801053b6:	85 c0                	test   %eax,%eax
801053b8:	78 26                	js     801053e0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801053ba:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053c0:	85 c0                	test   %eax,%eax
801053c2:	74 2c                	je     801053f0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053c4:	83 ec 08             	sub    $0x8,%esp
801053c7:	56                   	push   %esi
801053c8:	50                   	push   %eax
801053c9:	e8 82 f3 ff ff       	call   80104750 <fetchstr>
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	85 c0                	test   %eax,%eax
801053d3:	78 0b                	js     801053e0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801053d5:	83 c3 01             	add    $0x1,%ebx
801053d8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801053db:	83 fb 20             	cmp    $0x20,%ebx
801053de:	75 c0                	jne    801053a0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801053e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053e8:	5b                   	pop    %ebx
801053e9:	5e                   	pop    %esi
801053ea:	5f                   	pop    %edi
801053eb:	5d                   	pop    %ebp
801053ec:	c3                   	ret    
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801053f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053f6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801053f9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105400:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105404:	50                   	push   %eax
80105405:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010540b:	e8 e0 b5 ff ff       	call   801009f0 <exec>
80105410:	83 c4 10             	add    $0x10,%esp
}
80105413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105416:	5b                   	pop    %ebx
80105417:	5e                   	pop    %esi
80105418:	5f                   	pop    %edi
80105419:	5d                   	pop    %ebp
8010541a:	c3                   	ret    
8010541b:	90                   	nop
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_pipe>:

int
sys_pipe(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	57                   	push   %edi
80105424:	56                   	push   %esi
80105425:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105426:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105429:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010542c:	6a 08                	push   $0x8
8010542e:	50                   	push   %eax
8010542f:	6a 00                	push   $0x0
80105431:	e8 ca f3 ff ff       	call   80104800 <argptr>
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	85 c0                	test   %eax,%eax
8010543b:	78 4a                	js     80105487 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010543d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105440:	83 ec 08             	sub    $0x8,%esp
80105443:	50                   	push   %eax
80105444:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105447:	50                   	push   %eax
80105448:	e8 23 de ff ff       	call   80103270 <pipealloc>
8010544d:	83 c4 10             	add    $0x10,%esp
80105450:	85 c0                	test   %eax,%eax
80105452:	78 33                	js     80105487 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105454:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105456:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105459:	e8 a2 e3 ff ff       	call   80103800 <myproc>
8010545e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105460:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105464:	85 f6                	test   %esi,%esi
80105466:	74 30                	je     80105498 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105468:	83 c3 01             	add    $0x1,%ebx
8010546b:	83 fb 10             	cmp    $0x10,%ebx
8010546e:	75 f0                	jne    80105460 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	ff 75 e0             	pushl  -0x20(%ebp)
80105476:	e8 b5 b9 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
8010547b:	58                   	pop    %eax
8010547c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010547f:	e8 ac b9 ff ff       	call   80100e30 <fileclose>
    return -1;
80105484:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010548a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010548f:	5b                   	pop    %ebx
80105490:	5e                   	pop    %esi
80105491:	5f                   	pop    %edi
80105492:	5d                   	pop    %ebp
80105493:	c3                   	ret    
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105498:	8d 73 08             	lea    0x8(%ebx),%esi
8010549b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010549f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801054a2:	e8 59 e3 ff ff       	call   80103800 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801054a7:	31 d2                	xor    %edx,%edx
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054b0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801054b4:	85 c9                	test   %ecx,%ecx
801054b6:	74 18                	je     801054d0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801054b8:	83 c2 01             	add    $0x1,%edx
801054bb:	83 fa 10             	cmp    $0x10,%edx
801054be:	75 f0                	jne    801054b0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801054c0:	e8 3b e3 ff ff       	call   80103800 <myproc>
801054c5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801054cc:	00 
801054cd:	eb a1                	jmp    80105470 <sys_pipe+0x50>
801054cf:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801054d0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801054d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054d7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801054d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801054df:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801054e2:	31 c0                	xor    %eax,%eax
}
801054e4:	5b                   	pop    %ebx
801054e5:	5e                   	pop    %esi
801054e6:	5f                   	pop    %edi
801054e7:	5d                   	pop    %ebp
801054e8:	c3                   	ret    
801054e9:	66 90                	xchg   %ax,%ax
801054eb:	66 90                	xchg   %ax,%ax
801054ed:	66 90                	xchg   %ax,%ax
801054ef:	90                   	nop

801054f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801054f3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801054f4:	e9 a7 e4 ff ff       	jmp    801039a0 <fork>
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_exit>:
}

int
sys_exit(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 08             	sub    $0x8,%esp
  exit();
80105506:	e8 25 e7 ff ff       	call   80103c30 <exit>
  return 0;  // not reached
}
8010550b:	31 c0                	xor    %eax,%eax
8010550d:	c9                   	leave  
8010550e:	c3                   	ret    
8010550f:	90                   	nop

80105510 <sys_wait>:

int
sys_wait(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105513:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105514:	e9 57 e9 ff ff       	jmp    80103e70 <wait>
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_kill>:
}

int
sys_kill(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105526:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105529:	50                   	push   %eax
8010552a:	6a 00                	push   $0x0
8010552c:	e8 7f f2 ff ff       	call   801047b0 <argint>
80105531:	83 c4 10             	add    $0x10,%esp
80105534:	85 c0                	test   %eax,%eax
80105536:	78 18                	js     80105550 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	ff 75 f4             	pushl  -0xc(%ebp)
8010553e:	e8 7d ea ff ff       	call   80103fc0 <kill>
80105543:	83 c4 10             	add    $0x10,%esp
}
80105546:	c9                   	leave  
80105547:	c3                   	ret    
80105548:	90                   	nop
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_getpid>:

int
sys_getpid(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105566:	e8 95 e2 ff ff       	call   80103800 <myproc>
8010556b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010556e:	c9                   	leave  
8010556f:	c3                   	ret    

80105570 <sys_sbrk>:

int
sys_sbrk(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105574:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105577:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010557a:	50                   	push   %eax
8010557b:	6a 00                	push   $0x0
8010557d:	e8 2e f2 ff ff       	call   801047b0 <argint>
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	85 c0                	test   %eax,%eax
80105587:	78 27                	js     801055b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105589:	e8 72 e2 ff ff       	call   80103800 <myproc>
  if(growproc(n) < 0)
8010558e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105591:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105593:	ff 75 f4             	pushl  -0xc(%ebp)
80105596:	e8 85 e3 ff ff       	call   80103920 <growproc>
8010559b:	83 c4 10             	add    $0x10,%esp
8010559e:	85 c0                	test   %eax,%eax
801055a0:	78 0e                	js     801055b0 <sys_sbrk+0x40>
    return -1;
  return addr;
801055a2:	89 d8                	mov    %ebx,%eax
}
801055a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055a7:	c9                   	leave  
801055a8:	c3                   	ret    
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b5:	eb ed                	jmp    801055a4 <sys_sbrk+0x34>
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801055c7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055ca:	50                   	push   %eax
801055cb:	6a 00                	push   $0x0
801055cd:	e8 de f1 ff ff       	call   801047b0 <argint>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	0f 88 8a 00 00 00    	js     80105667 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801055dd:	83 ec 0c             	sub    $0xc,%esp
801055e0:	68 60 4c 11 80       	push   $0x80114c60
801055e5:	e8 b6 ed ff ff       	call   801043a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055ed:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801055f0:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
801055f6:	85 d2                	test   %edx,%edx
801055f8:	75 27                	jne    80105621 <sys_sleep+0x61>
801055fa:	eb 54                	jmp    80105650 <sys_sleep+0x90>
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	68 60 4c 11 80       	push   $0x80114c60
80105608:	68 a0 54 11 80       	push   $0x801154a0
8010560d:	e8 9e e7 ff ff       	call   80103db0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105612:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105617:	83 c4 10             	add    $0x10,%esp
8010561a:	29 d8                	sub    %ebx,%eax
8010561c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010561f:	73 2f                	jae    80105650 <sys_sleep+0x90>
    if(myproc()->killed){
80105621:	e8 da e1 ff ff       	call   80103800 <myproc>
80105626:	8b 40 24             	mov    0x24(%eax),%eax
80105629:	85 c0                	test   %eax,%eax
8010562b:	74 d3                	je     80105600 <sys_sleep+0x40>
      release(&tickslock);
8010562d:	83 ec 0c             	sub    $0xc,%esp
80105630:	68 60 4c 11 80       	push   $0x80114c60
80105635:	e8 16 ee ff ff       	call   80104450 <release>
      return -1;
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	68 60 4c 11 80       	push   $0x80114c60
80105658:	e8 f3 ed ff ff       	call   80104450 <release>
  return 0;
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	31 c0                	xor    %eax,%eax
}
80105662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105665:	c9                   	leave  
80105666:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566c:	eb d4                	jmp    80105642 <sys_sleep+0x82>
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	53                   	push   %ebx
80105674:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105677:	68 60 4c 11 80       	push   $0x80114c60
8010567c:	e8 1f ed ff ff       	call   801043a0 <acquire>
  xticks = ticks;
80105681:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105687:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010568e:	e8 bd ed ff ff       	call   80104450 <release>
  return xticks;
}
80105693:	89 d8                	mov    %ebx,%eax
80105695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105698:	c9                   	leave  
80105699:	c3                   	ret    

8010569a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010569a:	1e                   	push   %ds
  pushl %es
8010569b:	06                   	push   %es
  pushl %fs
8010569c:	0f a0                	push   %fs
  pushl %gs
8010569e:	0f a8                	push   %gs
  pushal
801056a0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801056a1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801056a5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801056a7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801056a9:	54                   	push   %esp
  call trap
801056aa:	e8 e1 00 00 00       	call   80105790 <trap>
  addl $4, %esp
801056af:	83 c4 04             	add    $0x4,%esp

801056b2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801056b2:	61                   	popa   
  popl %gs
801056b3:	0f a9                	pop    %gs
  popl %fs
801056b5:	0f a1                	pop    %fs
  popl %es
801056b7:	07                   	pop    %es
  popl %ds
801056b8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801056b9:	83 c4 08             	add    $0x8,%esp
  iret
801056bc:	cf                   	iret   
801056bd:	66 90                	xchg   %ax,%ax
801056bf:	90                   	nop

801056c0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056c0:	31 c0                	xor    %eax,%eax
801056c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801056c8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801056cf:	b9 08 00 00 00       	mov    $0x8,%ecx
801056d4:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
801056db:	00 
801056dc:	66 89 0c c5 a2 4c 11 	mov    %cx,-0x7feeb35e(,%eax,8)
801056e3:	80 
801056e4:	c6 04 c5 a5 4c 11 80 	movb   $0x8e,-0x7feeb35b(,%eax,8)
801056eb:	8e 
801056ec:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
801056f3:	80 
801056f4:	c1 ea 10             	shr    $0x10,%edx
801056f7:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801056fe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056ff:	83 c0 01             	add    $0x1,%eax
80105702:	3d 00 01 00 00       	cmp    $0x100,%eax
80105707:	75 bf                	jne    801056c8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105709:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010570a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010570f:	89 e5                	mov    %esp,%ebp
80105711:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105714:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105719:	68 f9 76 10 80       	push   $0x801076f9
8010571e:	68 60 4c 11 80       	push   $0x80114c60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105723:	66 89 15 a2 4e 11 80 	mov    %dx,0x80114ea2
8010572a:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
80105731:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105737:	c1 e8 10             	shr    $0x10,%eax
8010573a:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
80105741:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6

  initlock(&tickslock, "time");
80105747:	e8 f4 ea ff ff       	call   80104240 <initlock>
}
8010574c:	83 c4 10             	add    $0x10,%esp
8010574f:	c9                   	leave  
80105750:	c3                   	ret    
80105751:	eb 0d                	jmp    80105760 <idtinit>
80105753:	90                   	nop
80105754:	90                   	nop
80105755:	90                   	nop
80105756:	90                   	nop
80105757:	90                   	nop
80105758:	90                   	nop
80105759:	90                   	nop
8010575a:	90                   	nop
8010575b:	90                   	nop
8010575c:	90                   	nop
8010575d:	90                   	nop
8010575e:	90                   	nop
8010575f:	90                   	nop

80105760 <idtinit>:

void
idtinit(void)
{
80105760:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105761:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105766:	89 e5                	mov    %esp,%ebp
80105768:	83 ec 10             	sub    $0x10,%esp
8010576b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010576f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105774:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105778:	c1 e8 10             	shr    $0x10,%eax
8010577b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010577f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105782:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105785:	c9                   	leave  
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
80105795:	53                   	push   %ebx
80105796:	83 ec 1c             	sub    $0x1c,%esp
80105799:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010579c:	8b 47 30             	mov    0x30(%edi),%eax
8010579f:	83 f8 40             	cmp    $0x40,%eax
801057a2:	0f 84 88 01 00 00    	je     80105930 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801057a8:	83 e8 20             	sub    $0x20,%eax
801057ab:	83 f8 1f             	cmp    $0x1f,%eax
801057ae:	77 10                	ja     801057c0 <trap+0x30>
801057b0:	ff 24 85 a0 77 10 80 	jmp    *-0x7fef8860(,%eax,4)
801057b7:	89 f6                	mov    %esi,%esi
801057b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801057c0:	e8 3b e0 ff ff       	call   80103800 <myproc>
801057c5:	85 c0                	test   %eax,%eax
801057c7:	0f 84 d7 01 00 00    	je     801059a4 <trap+0x214>
801057cd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801057d1:	0f 84 cd 01 00 00    	je     801059a4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057d7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057da:	8b 57 38             	mov    0x38(%edi),%edx
801057dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801057e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801057e3:	e8 f8 df ff ff       	call   801037e0 <cpuid>
801057e8:	8b 77 34             	mov    0x34(%edi),%esi
801057eb:	8b 5f 30             	mov    0x30(%edi),%ebx
801057ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057f1:	e8 0a e0 ff ff       	call   80103800 <myproc>
801057f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801057f9:	e8 02 e0 ff ff       	call   80103800 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105801:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105804:	51                   	push   %ecx
80105805:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105806:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105809:	ff 75 e4             	pushl  -0x1c(%ebp)
8010580c:	56                   	push   %esi
8010580d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010580e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105811:	52                   	push   %edx
80105812:	ff 70 10             	pushl  0x10(%eax)
80105815:	68 5c 77 10 80       	push   $0x8010775c
8010581a:	e8 41 ae ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010581f:	83 c4 20             	add    $0x20,%esp
80105822:	e8 d9 df ff ff       	call   80103800 <myproc>
80105827:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010582e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105830:	e8 cb df ff ff       	call   80103800 <myproc>
80105835:	85 c0                	test   %eax,%eax
80105837:	74 0c                	je     80105845 <trap+0xb5>
80105839:	e8 c2 df ff ff       	call   80103800 <myproc>
8010583e:	8b 50 24             	mov    0x24(%eax),%edx
80105841:	85 d2                	test   %edx,%edx
80105843:	75 4b                	jne    80105890 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105845:	e8 b6 df ff ff       	call   80103800 <myproc>
8010584a:	85 c0                	test   %eax,%eax
8010584c:	74 0b                	je     80105859 <trap+0xc9>
8010584e:	e8 ad df ff ff       	call   80103800 <myproc>
80105853:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105857:	74 4f                	je     801058a8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105859:	e8 a2 df ff ff       	call   80103800 <myproc>
8010585e:	85 c0                	test   %eax,%eax
80105860:	74 1d                	je     8010587f <trap+0xef>
80105862:	e8 99 df ff ff       	call   80103800 <myproc>
80105867:	8b 40 24             	mov    0x24(%eax),%eax
8010586a:	85 c0                	test   %eax,%eax
8010586c:	74 11                	je     8010587f <trap+0xef>
8010586e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105872:	83 e0 03             	and    $0x3,%eax
80105875:	66 83 f8 03          	cmp    $0x3,%ax
80105879:	0f 84 da 00 00 00    	je     80105959 <trap+0x1c9>
    exit();
}
8010587f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105882:	5b                   	pop    %ebx
80105883:	5e                   	pop    %esi
80105884:	5f                   	pop    %edi
80105885:	5d                   	pop    %ebp
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105890:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105894:	83 e0 03             	and    $0x3,%eax
80105897:	66 83 f8 03          	cmp    $0x3,%ax
8010589b:	75 a8                	jne    80105845 <trap+0xb5>
    exit();
8010589d:	e8 8e e3 ff ff       	call   80103c30 <exit>
801058a2:	eb a1                	jmp    80105845 <trap+0xb5>
801058a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058a8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801058ac:	75 ab                	jne    80105859 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801058ae:	e8 ad e4 ff ff       	call   80103d60 <yield>
801058b3:	eb a4                	jmp    80105859 <trap+0xc9>
801058b5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801058b8:	e8 23 df ff ff       	call   801037e0 <cpuid>
801058bd:	85 c0                	test   %eax,%eax
801058bf:	0f 84 ab 00 00 00    	je     80105970 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801058c5:	e8 c6 ce ff ff       	call   80102790 <lapiceoi>
    break;
801058ca:	e9 61 ff ff ff       	jmp    80105830 <trap+0xa0>
801058cf:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801058d0:	e8 7b cd ff ff       	call   80102650 <kbdintr>
    lapiceoi();
801058d5:	e8 b6 ce ff ff       	call   80102790 <lapiceoi>
    break;
801058da:	e9 51 ff ff ff       	jmp    80105830 <trap+0xa0>
801058df:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801058e0:	e8 5b 02 00 00       	call   80105b40 <uartintr>
    lapiceoi();
801058e5:	e8 a6 ce ff ff       	call   80102790 <lapiceoi>
    break;
801058ea:	e9 41 ff ff ff       	jmp    80105830 <trap+0xa0>
801058ef:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801058f0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801058f4:	8b 77 38             	mov    0x38(%edi),%esi
801058f7:	e8 e4 de ff ff       	call   801037e0 <cpuid>
801058fc:	56                   	push   %esi
801058fd:	53                   	push   %ebx
801058fe:	50                   	push   %eax
801058ff:	68 04 77 10 80       	push   $0x80107704
80105904:	e8 57 ad ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105909:	e8 82 ce ff ff       	call   80102790 <lapiceoi>
    break;
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	e9 1a ff ff ff       	jmp    80105830 <trap+0xa0>
80105916:	8d 76 00             	lea    0x0(%esi),%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105920:	e8 ab c7 ff ff       	call   801020d0 <ideintr>
80105925:	eb 9e                	jmp    801058c5 <trap+0x135>
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105930:	e8 cb de ff ff       	call   80103800 <myproc>
80105935:	8b 58 24             	mov    0x24(%eax),%ebx
80105938:	85 db                	test   %ebx,%ebx
8010593a:	75 2c                	jne    80105968 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010593c:	e8 bf de ff ff       	call   80103800 <myproc>
80105941:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105944:	e8 57 ef ff ff       	call   801048a0 <syscall>
    if(myproc()->killed)
80105949:	e8 b2 de ff ff       	call   80103800 <myproc>
8010594e:	8b 48 24             	mov    0x24(%eax),%ecx
80105951:	85 c9                	test   %ecx,%ecx
80105953:	0f 84 26 ff ff ff    	je     8010587f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010595c:	5b                   	pop    %ebx
8010595d:	5e                   	pop    %esi
8010595e:	5f                   	pop    %edi
8010595f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105960:	e9 cb e2 ff ff       	jmp    80103c30 <exit>
80105965:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105968:	e8 c3 e2 ff ff       	call   80103c30 <exit>
8010596d:	eb cd                	jmp    8010593c <trap+0x1ac>
8010596f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	68 60 4c 11 80       	push   $0x80114c60
80105978:	e8 23 ea ff ff       	call   801043a0 <acquire>
      ticks++;
      wakeup(&ticks);
8010597d:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105984:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
8010598b:	e8 d0 e5 ff ff       	call   80103f60 <wakeup>
      release(&tickslock);
80105990:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105997:	e8 b4 ea ff ff       	call   80104450 <release>
8010599c:	83 c4 10             	add    $0x10,%esp
8010599f:	e9 21 ff ff ff       	jmp    801058c5 <trap+0x135>
801059a4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801059aa:	e8 31 de ff ff       	call   801037e0 <cpuid>
801059af:	83 ec 0c             	sub    $0xc,%esp
801059b2:	56                   	push   %esi
801059b3:	53                   	push   %ebx
801059b4:	50                   	push   %eax
801059b5:	ff 77 30             	pushl  0x30(%edi)
801059b8:	68 28 77 10 80       	push   $0x80107728
801059bd:	e8 9e ac ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801059c2:	83 c4 14             	add    $0x14,%esp
801059c5:	68 fe 76 10 80       	push   $0x801076fe
801059ca:	e8 a1 a9 ff ff       	call   80100370 <panic>
801059cf:	90                   	nop

801059d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059d0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801059d5:	55                   	push   %ebp
801059d6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059d8:	85 c0                	test   %eax,%eax
801059da:	74 1c                	je     801059f8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059dc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059e1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801059e2:	a8 01                	test   $0x1,%al
801059e4:	74 12                	je     801059f8 <uartgetc+0x28>
801059e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059eb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801059ec:	0f b6 c0             	movzbl %al,%eax
}
801059ef:	5d                   	pop    %ebp
801059f0:	c3                   	ret    
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801059f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801059fd:	5d                   	pop    %ebp
801059fe:	c3                   	ret    
801059ff:	90                   	nop

80105a00 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	56                   	push   %esi
80105a05:	53                   	push   %ebx
80105a06:	89 c7                	mov    %eax,%edi
80105a08:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a12:	83 ec 0c             	sub    $0xc,%esp
80105a15:	eb 1b                	jmp    80105a32 <uartputc.part.0+0x32>
80105a17:	89 f6                	mov    %esi,%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	6a 0a                	push   $0xa
80105a25:	e8 86 cd ff ff       	call   801027b0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a2a:	83 c4 10             	add    $0x10,%esp
80105a2d:	83 eb 01             	sub    $0x1,%ebx
80105a30:	74 07                	je     80105a39 <uartputc.part.0+0x39>
80105a32:	89 f2                	mov    %esi,%edx
80105a34:	ec                   	in     (%dx),%al
80105a35:	a8 20                	test   $0x20,%al
80105a37:	74 e7                	je     80105a20 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a3e:	89 f8                	mov    %edi,%eax
80105a40:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105a41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a44:	5b                   	pop    %ebx
80105a45:	5e                   	pop    %esi
80105a46:	5f                   	pop    %edi
80105a47:	5d                   	pop    %ebp
80105a48:	c3                   	ret    
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a50 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105a50:	55                   	push   %ebp
80105a51:	31 c9                	xor    %ecx,%ecx
80105a53:	89 c8                	mov    %ecx,%eax
80105a55:	89 e5                	mov    %esp,%ebp
80105a57:	57                   	push   %edi
80105a58:	56                   	push   %esi
80105a59:	53                   	push   %ebx
80105a5a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105a5f:	89 da                	mov    %ebx,%edx
80105a61:	83 ec 0c             	sub    $0xc,%esp
80105a64:	ee                   	out    %al,(%dx)
80105a65:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105a6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a6f:	89 fa                	mov    %edi,%edx
80105a71:	ee                   	out    %al,(%dx)
80105a72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a7c:	ee                   	out    %al,(%dx)
80105a7d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105a82:	89 c8                	mov    %ecx,%eax
80105a84:	89 f2                	mov    %esi,%edx
80105a86:	ee                   	out    %al,(%dx)
80105a87:	b8 03 00 00 00       	mov    $0x3,%eax
80105a8c:	89 fa                	mov    %edi,%edx
80105a8e:	ee                   	out    %al,(%dx)
80105a8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105a94:	89 c8                	mov    %ecx,%eax
80105a96:	ee                   	out    %al,(%dx)
80105a97:	b8 01 00 00 00       	mov    $0x1,%eax
80105a9c:	89 f2                	mov    %esi,%edx
80105a9e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105aa4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105aa5:	3c ff                	cmp    $0xff,%al
80105aa7:	74 5a                	je     80105b03 <uartinit+0xb3>
    return;
  uart = 1;
80105aa9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ab0:	00 00 00 
80105ab3:	89 da                	mov    %ebx,%edx
80105ab5:	ec                   	in     (%dx),%al
80105ab6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105abb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105abc:	83 ec 08             	sub    $0x8,%esp
80105abf:	bb 20 78 10 80       	mov    $0x80107820,%ebx
80105ac4:	6a 00                	push   $0x0
80105ac6:	6a 04                	push   $0x4
80105ac8:	e8 53 c8 ff ff       	call   80102320 <ioapicenable>
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	b8 78 00 00 00       	mov    $0x78,%eax
80105ad5:	eb 13                	jmp    80105aea <uartinit+0x9a>
80105ad7:	89 f6                	mov    %esi,%esi
80105ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105ae0:	83 c3 01             	add    $0x1,%ebx
80105ae3:	0f be 03             	movsbl (%ebx),%eax
80105ae6:	84 c0                	test   %al,%al
80105ae8:	74 19                	je     80105b03 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105aea:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105af0:	85 d2                	test   %edx,%edx
80105af2:	74 ec                	je     80105ae0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105af4:	83 c3 01             	add    $0x1,%ebx
80105af7:	e8 04 ff ff ff       	call   80105a00 <uartputc.part.0>
80105afc:	0f be 03             	movsbl (%ebx),%eax
80105aff:	84 c0                	test   %al,%al
80105b01:	75 e7                	jne    80105aea <uartinit+0x9a>
    uartputc(*p);
}
80105b03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b06:	5b                   	pop    %ebx
80105b07:	5e                   	pop    %esi
80105b08:	5f                   	pop    %edi
80105b09:	5d                   	pop    %ebp
80105b0a:	c3                   	ret    
80105b0b:	90                   	nop
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b10 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b10:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b16:	55                   	push   %ebp
80105b17:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105b19:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105b1e:	74 10                	je     80105b30 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105b20:	5d                   	pop    %ebp
80105b21:	e9 da fe ff ff       	jmp    80105a00 <uartputc.part.0>
80105b26:	8d 76 00             	lea    0x0(%esi),%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b30:	5d                   	pop    %ebp
80105b31:	c3                   	ret    
80105b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b40 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b46:	68 d0 59 10 80       	push   $0x801059d0
80105b4b:	e8 a0 ac ff ff       	call   801007f0 <consoleintr>
}
80105b50:	83 c4 10             	add    $0x10,%esp
80105b53:	c9                   	leave  
80105b54:	c3                   	ret    

80105b55 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b55:	6a 00                	push   $0x0
  pushl $0
80105b57:	6a 00                	push   $0x0
  jmp alltraps
80105b59:	e9 3c fb ff ff       	jmp    8010569a <alltraps>

80105b5e <vector1>:
.globl vector1
vector1:
  pushl $0
80105b5e:	6a 00                	push   $0x0
  pushl $1
80105b60:	6a 01                	push   $0x1
  jmp alltraps
80105b62:	e9 33 fb ff ff       	jmp    8010569a <alltraps>

80105b67 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b67:	6a 00                	push   $0x0
  pushl $2
80105b69:	6a 02                	push   $0x2
  jmp alltraps
80105b6b:	e9 2a fb ff ff       	jmp    8010569a <alltraps>

80105b70 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b70:	6a 00                	push   $0x0
  pushl $3
80105b72:	6a 03                	push   $0x3
  jmp alltraps
80105b74:	e9 21 fb ff ff       	jmp    8010569a <alltraps>

80105b79 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b79:	6a 00                	push   $0x0
  pushl $4
80105b7b:	6a 04                	push   $0x4
  jmp alltraps
80105b7d:	e9 18 fb ff ff       	jmp    8010569a <alltraps>

80105b82 <vector5>:
.globl vector5
vector5:
  pushl $0
80105b82:	6a 00                	push   $0x0
  pushl $5
80105b84:	6a 05                	push   $0x5
  jmp alltraps
80105b86:	e9 0f fb ff ff       	jmp    8010569a <alltraps>

80105b8b <vector6>:
.globl vector6
vector6:
  pushl $0
80105b8b:	6a 00                	push   $0x0
  pushl $6
80105b8d:	6a 06                	push   $0x6
  jmp alltraps
80105b8f:	e9 06 fb ff ff       	jmp    8010569a <alltraps>

80105b94 <vector7>:
.globl vector7
vector7:
  pushl $0
80105b94:	6a 00                	push   $0x0
  pushl $7
80105b96:	6a 07                	push   $0x7
  jmp alltraps
80105b98:	e9 fd fa ff ff       	jmp    8010569a <alltraps>

80105b9d <vector8>:
.globl vector8
vector8:
  pushl $8
80105b9d:	6a 08                	push   $0x8
  jmp alltraps
80105b9f:	e9 f6 fa ff ff       	jmp    8010569a <alltraps>

80105ba4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $9
80105ba6:	6a 09                	push   $0x9
  jmp alltraps
80105ba8:	e9 ed fa ff ff       	jmp    8010569a <alltraps>

80105bad <vector10>:
.globl vector10
vector10:
  pushl $10
80105bad:	6a 0a                	push   $0xa
  jmp alltraps
80105baf:	e9 e6 fa ff ff       	jmp    8010569a <alltraps>

80105bb4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bb4:	6a 0b                	push   $0xb
  jmp alltraps
80105bb6:	e9 df fa ff ff       	jmp    8010569a <alltraps>

80105bbb <vector12>:
.globl vector12
vector12:
  pushl $12
80105bbb:	6a 0c                	push   $0xc
  jmp alltraps
80105bbd:	e9 d8 fa ff ff       	jmp    8010569a <alltraps>

80105bc2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105bc2:	6a 0d                	push   $0xd
  jmp alltraps
80105bc4:	e9 d1 fa ff ff       	jmp    8010569a <alltraps>

80105bc9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105bc9:	6a 0e                	push   $0xe
  jmp alltraps
80105bcb:	e9 ca fa ff ff       	jmp    8010569a <alltraps>

80105bd0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $15
80105bd2:	6a 0f                	push   $0xf
  jmp alltraps
80105bd4:	e9 c1 fa ff ff       	jmp    8010569a <alltraps>

80105bd9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $16
80105bdb:	6a 10                	push   $0x10
  jmp alltraps
80105bdd:	e9 b8 fa ff ff       	jmp    8010569a <alltraps>

80105be2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105be2:	6a 11                	push   $0x11
  jmp alltraps
80105be4:	e9 b1 fa ff ff       	jmp    8010569a <alltraps>

80105be9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $18
80105beb:	6a 12                	push   $0x12
  jmp alltraps
80105bed:	e9 a8 fa ff ff       	jmp    8010569a <alltraps>

80105bf2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105bf2:	6a 00                	push   $0x0
  pushl $19
80105bf4:	6a 13                	push   $0x13
  jmp alltraps
80105bf6:	e9 9f fa ff ff       	jmp    8010569a <alltraps>

80105bfb <vector20>:
.globl vector20
vector20:
  pushl $0
80105bfb:	6a 00                	push   $0x0
  pushl $20
80105bfd:	6a 14                	push   $0x14
  jmp alltraps
80105bff:	e9 96 fa ff ff       	jmp    8010569a <alltraps>

80105c04 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $21
80105c06:	6a 15                	push   $0x15
  jmp alltraps
80105c08:	e9 8d fa ff ff       	jmp    8010569a <alltraps>

80105c0d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c0d:	6a 00                	push   $0x0
  pushl $22
80105c0f:	6a 16                	push   $0x16
  jmp alltraps
80105c11:	e9 84 fa ff ff       	jmp    8010569a <alltraps>

80105c16 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $23
80105c18:	6a 17                	push   $0x17
  jmp alltraps
80105c1a:	e9 7b fa ff ff       	jmp    8010569a <alltraps>

80105c1f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c1f:	6a 00                	push   $0x0
  pushl $24
80105c21:	6a 18                	push   $0x18
  jmp alltraps
80105c23:	e9 72 fa ff ff       	jmp    8010569a <alltraps>

80105c28 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $25
80105c2a:	6a 19                	push   $0x19
  jmp alltraps
80105c2c:	e9 69 fa ff ff       	jmp    8010569a <alltraps>

80105c31 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $26
80105c33:	6a 1a                	push   $0x1a
  jmp alltraps
80105c35:	e9 60 fa ff ff       	jmp    8010569a <alltraps>

80105c3a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $27
80105c3c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c3e:	e9 57 fa ff ff       	jmp    8010569a <alltraps>

80105c43 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $28
80105c45:	6a 1c                	push   $0x1c
  jmp alltraps
80105c47:	e9 4e fa ff ff       	jmp    8010569a <alltraps>

80105c4c <vector29>:
.globl vector29
vector29:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $29
80105c4e:	6a 1d                	push   $0x1d
  jmp alltraps
80105c50:	e9 45 fa ff ff       	jmp    8010569a <alltraps>

80105c55 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $30
80105c57:	6a 1e                	push   $0x1e
  jmp alltraps
80105c59:	e9 3c fa ff ff       	jmp    8010569a <alltraps>

80105c5e <vector31>:
.globl vector31
vector31:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $31
80105c60:	6a 1f                	push   $0x1f
  jmp alltraps
80105c62:	e9 33 fa ff ff       	jmp    8010569a <alltraps>

80105c67 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $32
80105c69:	6a 20                	push   $0x20
  jmp alltraps
80105c6b:	e9 2a fa ff ff       	jmp    8010569a <alltraps>

80105c70 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $33
80105c72:	6a 21                	push   $0x21
  jmp alltraps
80105c74:	e9 21 fa ff ff       	jmp    8010569a <alltraps>

80105c79 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $34
80105c7b:	6a 22                	push   $0x22
  jmp alltraps
80105c7d:	e9 18 fa ff ff       	jmp    8010569a <alltraps>

80105c82 <vector35>:
.globl vector35
vector35:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $35
80105c84:	6a 23                	push   $0x23
  jmp alltraps
80105c86:	e9 0f fa ff ff       	jmp    8010569a <alltraps>

80105c8b <vector36>:
.globl vector36
vector36:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $36
80105c8d:	6a 24                	push   $0x24
  jmp alltraps
80105c8f:	e9 06 fa ff ff       	jmp    8010569a <alltraps>

80105c94 <vector37>:
.globl vector37
vector37:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $37
80105c96:	6a 25                	push   $0x25
  jmp alltraps
80105c98:	e9 fd f9 ff ff       	jmp    8010569a <alltraps>

80105c9d <vector38>:
.globl vector38
vector38:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $38
80105c9f:	6a 26                	push   $0x26
  jmp alltraps
80105ca1:	e9 f4 f9 ff ff       	jmp    8010569a <alltraps>

80105ca6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $39
80105ca8:	6a 27                	push   $0x27
  jmp alltraps
80105caa:	e9 eb f9 ff ff       	jmp    8010569a <alltraps>

80105caf <vector40>:
.globl vector40
vector40:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $40
80105cb1:	6a 28                	push   $0x28
  jmp alltraps
80105cb3:	e9 e2 f9 ff ff       	jmp    8010569a <alltraps>

80105cb8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $41
80105cba:	6a 29                	push   $0x29
  jmp alltraps
80105cbc:	e9 d9 f9 ff ff       	jmp    8010569a <alltraps>

80105cc1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $42
80105cc3:	6a 2a                	push   $0x2a
  jmp alltraps
80105cc5:	e9 d0 f9 ff ff       	jmp    8010569a <alltraps>

80105cca <vector43>:
.globl vector43
vector43:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $43
80105ccc:	6a 2b                	push   $0x2b
  jmp alltraps
80105cce:	e9 c7 f9 ff ff       	jmp    8010569a <alltraps>

80105cd3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $44
80105cd5:	6a 2c                	push   $0x2c
  jmp alltraps
80105cd7:	e9 be f9 ff ff       	jmp    8010569a <alltraps>

80105cdc <vector45>:
.globl vector45
vector45:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $45
80105cde:	6a 2d                	push   $0x2d
  jmp alltraps
80105ce0:	e9 b5 f9 ff ff       	jmp    8010569a <alltraps>

80105ce5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $46
80105ce7:	6a 2e                	push   $0x2e
  jmp alltraps
80105ce9:	e9 ac f9 ff ff       	jmp    8010569a <alltraps>

80105cee <vector47>:
.globl vector47
vector47:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $47
80105cf0:	6a 2f                	push   $0x2f
  jmp alltraps
80105cf2:	e9 a3 f9 ff ff       	jmp    8010569a <alltraps>

80105cf7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $48
80105cf9:	6a 30                	push   $0x30
  jmp alltraps
80105cfb:	e9 9a f9 ff ff       	jmp    8010569a <alltraps>

80105d00 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $49
80105d02:	6a 31                	push   $0x31
  jmp alltraps
80105d04:	e9 91 f9 ff ff       	jmp    8010569a <alltraps>

80105d09 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $50
80105d0b:	6a 32                	push   $0x32
  jmp alltraps
80105d0d:	e9 88 f9 ff ff       	jmp    8010569a <alltraps>

80105d12 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $51
80105d14:	6a 33                	push   $0x33
  jmp alltraps
80105d16:	e9 7f f9 ff ff       	jmp    8010569a <alltraps>

80105d1b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $52
80105d1d:	6a 34                	push   $0x34
  jmp alltraps
80105d1f:	e9 76 f9 ff ff       	jmp    8010569a <alltraps>

80105d24 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $53
80105d26:	6a 35                	push   $0x35
  jmp alltraps
80105d28:	e9 6d f9 ff ff       	jmp    8010569a <alltraps>

80105d2d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $54
80105d2f:	6a 36                	push   $0x36
  jmp alltraps
80105d31:	e9 64 f9 ff ff       	jmp    8010569a <alltraps>

80105d36 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $55
80105d38:	6a 37                	push   $0x37
  jmp alltraps
80105d3a:	e9 5b f9 ff ff       	jmp    8010569a <alltraps>

80105d3f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $56
80105d41:	6a 38                	push   $0x38
  jmp alltraps
80105d43:	e9 52 f9 ff ff       	jmp    8010569a <alltraps>

80105d48 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $57
80105d4a:	6a 39                	push   $0x39
  jmp alltraps
80105d4c:	e9 49 f9 ff ff       	jmp    8010569a <alltraps>

80105d51 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $58
80105d53:	6a 3a                	push   $0x3a
  jmp alltraps
80105d55:	e9 40 f9 ff ff       	jmp    8010569a <alltraps>

80105d5a <vector59>:
.globl vector59
vector59:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $59
80105d5c:	6a 3b                	push   $0x3b
  jmp alltraps
80105d5e:	e9 37 f9 ff ff       	jmp    8010569a <alltraps>

80105d63 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $60
80105d65:	6a 3c                	push   $0x3c
  jmp alltraps
80105d67:	e9 2e f9 ff ff       	jmp    8010569a <alltraps>

80105d6c <vector61>:
.globl vector61
vector61:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $61
80105d6e:	6a 3d                	push   $0x3d
  jmp alltraps
80105d70:	e9 25 f9 ff ff       	jmp    8010569a <alltraps>

80105d75 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $62
80105d77:	6a 3e                	push   $0x3e
  jmp alltraps
80105d79:	e9 1c f9 ff ff       	jmp    8010569a <alltraps>

80105d7e <vector63>:
.globl vector63
vector63:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $63
80105d80:	6a 3f                	push   $0x3f
  jmp alltraps
80105d82:	e9 13 f9 ff ff       	jmp    8010569a <alltraps>

80105d87 <vector64>:
.globl vector64
vector64:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $64
80105d89:	6a 40                	push   $0x40
  jmp alltraps
80105d8b:	e9 0a f9 ff ff       	jmp    8010569a <alltraps>

80105d90 <vector65>:
.globl vector65
vector65:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $65
80105d92:	6a 41                	push   $0x41
  jmp alltraps
80105d94:	e9 01 f9 ff ff       	jmp    8010569a <alltraps>

80105d99 <vector66>:
.globl vector66
vector66:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $66
80105d9b:	6a 42                	push   $0x42
  jmp alltraps
80105d9d:	e9 f8 f8 ff ff       	jmp    8010569a <alltraps>

80105da2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $67
80105da4:	6a 43                	push   $0x43
  jmp alltraps
80105da6:	e9 ef f8 ff ff       	jmp    8010569a <alltraps>

80105dab <vector68>:
.globl vector68
vector68:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $68
80105dad:	6a 44                	push   $0x44
  jmp alltraps
80105daf:	e9 e6 f8 ff ff       	jmp    8010569a <alltraps>

80105db4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $69
80105db6:	6a 45                	push   $0x45
  jmp alltraps
80105db8:	e9 dd f8 ff ff       	jmp    8010569a <alltraps>

80105dbd <vector70>:
.globl vector70
vector70:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $70
80105dbf:	6a 46                	push   $0x46
  jmp alltraps
80105dc1:	e9 d4 f8 ff ff       	jmp    8010569a <alltraps>

80105dc6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $71
80105dc8:	6a 47                	push   $0x47
  jmp alltraps
80105dca:	e9 cb f8 ff ff       	jmp    8010569a <alltraps>

80105dcf <vector72>:
.globl vector72
vector72:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $72
80105dd1:	6a 48                	push   $0x48
  jmp alltraps
80105dd3:	e9 c2 f8 ff ff       	jmp    8010569a <alltraps>

80105dd8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $73
80105dda:	6a 49                	push   $0x49
  jmp alltraps
80105ddc:	e9 b9 f8 ff ff       	jmp    8010569a <alltraps>

80105de1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $74
80105de3:	6a 4a                	push   $0x4a
  jmp alltraps
80105de5:	e9 b0 f8 ff ff       	jmp    8010569a <alltraps>

80105dea <vector75>:
.globl vector75
vector75:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $75
80105dec:	6a 4b                	push   $0x4b
  jmp alltraps
80105dee:	e9 a7 f8 ff ff       	jmp    8010569a <alltraps>

80105df3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $76
80105df5:	6a 4c                	push   $0x4c
  jmp alltraps
80105df7:	e9 9e f8 ff ff       	jmp    8010569a <alltraps>

80105dfc <vector77>:
.globl vector77
vector77:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $77
80105dfe:	6a 4d                	push   $0x4d
  jmp alltraps
80105e00:	e9 95 f8 ff ff       	jmp    8010569a <alltraps>

80105e05 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $78
80105e07:	6a 4e                	push   $0x4e
  jmp alltraps
80105e09:	e9 8c f8 ff ff       	jmp    8010569a <alltraps>

80105e0e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $79
80105e10:	6a 4f                	push   $0x4f
  jmp alltraps
80105e12:	e9 83 f8 ff ff       	jmp    8010569a <alltraps>

80105e17 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $80
80105e19:	6a 50                	push   $0x50
  jmp alltraps
80105e1b:	e9 7a f8 ff ff       	jmp    8010569a <alltraps>

80105e20 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $81
80105e22:	6a 51                	push   $0x51
  jmp alltraps
80105e24:	e9 71 f8 ff ff       	jmp    8010569a <alltraps>

80105e29 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $82
80105e2b:	6a 52                	push   $0x52
  jmp alltraps
80105e2d:	e9 68 f8 ff ff       	jmp    8010569a <alltraps>

80105e32 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $83
80105e34:	6a 53                	push   $0x53
  jmp alltraps
80105e36:	e9 5f f8 ff ff       	jmp    8010569a <alltraps>

80105e3b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $84
80105e3d:	6a 54                	push   $0x54
  jmp alltraps
80105e3f:	e9 56 f8 ff ff       	jmp    8010569a <alltraps>

80105e44 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $85
80105e46:	6a 55                	push   $0x55
  jmp alltraps
80105e48:	e9 4d f8 ff ff       	jmp    8010569a <alltraps>

80105e4d <vector86>:
.globl vector86
vector86:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $86
80105e4f:	6a 56                	push   $0x56
  jmp alltraps
80105e51:	e9 44 f8 ff ff       	jmp    8010569a <alltraps>

80105e56 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $87
80105e58:	6a 57                	push   $0x57
  jmp alltraps
80105e5a:	e9 3b f8 ff ff       	jmp    8010569a <alltraps>

80105e5f <vector88>:
.globl vector88
vector88:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $88
80105e61:	6a 58                	push   $0x58
  jmp alltraps
80105e63:	e9 32 f8 ff ff       	jmp    8010569a <alltraps>

80105e68 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $89
80105e6a:	6a 59                	push   $0x59
  jmp alltraps
80105e6c:	e9 29 f8 ff ff       	jmp    8010569a <alltraps>

80105e71 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $90
80105e73:	6a 5a                	push   $0x5a
  jmp alltraps
80105e75:	e9 20 f8 ff ff       	jmp    8010569a <alltraps>

80105e7a <vector91>:
.globl vector91
vector91:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $91
80105e7c:	6a 5b                	push   $0x5b
  jmp alltraps
80105e7e:	e9 17 f8 ff ff       	jmp    8010569a <alltraps>

80105e83 <vector92>:
.globl vector92
vector92:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $92
80105e85:	6a 5c                	push   $0x5c
  jmp alltraps
80105e87:	e9 0e f8 ff ff       	jmp    8010569a <alltraps>

80105e8c <vector93>:
.globl vector93
vector93:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $93
80105e8e:	6a 5d                	push   $0x5d
  jmp alltraps
80105e90:	e9 05 f8 ff ff       	jmp    8010569a <alltraps>

80105e95 <vector94>:
.globl vector94
vector94:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $94
80105e97:	6a 5e                	push   $0x5e
  jmp alltraps
80105e99:	e9 fc f7 ff ff       	jmp    8010569a <alltraps>

80105e9e <vector95>:
.globl vector95
vector95:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $95
80105ea0:	6a 5f                	push   $0x5f
  jmp alltraps
80105ea2:	e9 f3 f7 ff ff       	jmp    8010569a <alltraps>

80105ea7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $96
80105ea9:	6a 60                	push   $0x60
  jmp alltraps
80105eab:	e9 ea f7 ff ff       	jmp    8010569a <alltraps>

80105eb0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $97
80105eb2:	6a 61                	push   $0x61
  jmp alltraps
80105eb4:	e9 e1 f7 ff ff       	jmp    8010569a <alltraps>

80105eb9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $98
80105ebb:	6a 62                	push   $0x62
  jmp alltraps
80105ebd:	e9 d8 f7 ff ff       	jmp    8010569a <alltraps>

80105ec2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $99
80105ec4:	6a 63                	push   $0x63
  jmp alltraps
80105ec6:	e9 cf f7 ff ff       	jmp    8010569a <alltraps>

80105ecb <vector100>:
.globl vector100
vector100:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $100
80105ecd:	6a 64                	push   $0x64
  jmp alltraps
80105ecf:	e9 c6 f7 ff ff       	jmp    8010569a <alltraps>

80105ed4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $101
80105ed6:	6a 65                	push   $0x65
  jmp alltraps
80105ed8:	e9 bd f7 ff ff       	jmp    8010569a <alltraps>

80105edd <vector102>:
.globl vector102
vector102:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $102
80105edf:	6a 66                	push   $0x66
  jmp alltraps
80105ee1:	e9 b4 f7 ff ff       	jmp    8010569a <alltraps>

80105ee6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $103
80105ee8:	6a 67                	push   $0x67
  jmp alltraps
80105eea:	e9 ab f7 ff ff       	jmp    8010569a <alltraps>

80105eef <vector104>:
.globl vector104
vector104:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $104
80105ef1:	6a 68                	push   $0x68
  jmp alltraps
80105ef3:	e9 a2 f7 ff ff       	jmp    8010569a <alltraps>

80105ef8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ef8:	6a 00                	push   $0x0
  pushl $105
80105efa:	6a 69                	push   $0x69
  jmp alltraps
80105efc:	e9 99 f7 ff ff       	jmp    8010569a <alltraps>

80105f01 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f01:	6a 00                	push   $0x0
  pushl $106
80105f03:	6a 6a                	push   $0x6a
  jmp alltraps
80105f05:	e9 90 f7 ff ff       	jmp    8010569a <alltraps>

80105f0a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $107
80105f0c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f0e:	e9 87 f7 ff ff       	jmp    8010569a <alltraps>

80105f13 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $108
80105f15:	6a 6c                	push   $0x6c
  jmp alltraps
80105f17:	e9 7e f7 ff ff       	jmp    8010569a <alltraps>

80105f1c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f1c:	6a 00                	push   $0x0
  pushl $109
80105f1e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f20:	e9 75 f7 ff ff       	jmp    8010569a <alltraps>

80105f25 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $110
80105f27:	6a 6e                	push   $0x6e
  jmp alltraps
80105f29:	e9 6c f7 ff ff       	jmp    8010569a <alltraps>

80105f2e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $111
80105f30:	6a 6f                	push   $0x6f
  jmp alltraps
80105f32:	e9 63 f7 ff ff       	jmp    8010569a <alltraps>

80105f37 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $112
80105f39:	6a 70                	push   $0x70
  jmp alltraps
80105f3b:	e9 5a f7 ff ff       	jmp    8010569a <alltraps>

80105f40 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $113
80105f42:	6a 71                	push   $0x71
  jmp alltraps
80105f44:	e9 51 f7 ff ff       	jmp    8010569a <alltraps>

80105f49 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $114
80105f4b:	6a 72                	push   $0x72
  jmp alltraps
80105f4d:	e9 48 f7 ff ff       	jmp    8010569a <alltraps>

80105f52 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $115
80105f54:	6a 73                	push   $0x73
  jmp alltraps
80105f56:	e9 3f f7 ff ff       	jmp    8010569a <alltraps>

80105f5b <vector116>:
.globl vector116
vector116:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $116
80105f5d:	6a 74                	push   $0x74
  jmp alltraps
80105f5f:	e9 36 f7 ff ff       	jmp    8010569a <alltraps>

80105f64 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $117
80105f66:	6a 75                	push   $0x75
  jmp alltraps
80105f68:	e9 2d f7 ff ff       	jmp    8010569a <alltraps>

80105f6d <vector118>:
.globl vector118
vector118:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $118
80105f6f:	6a 76                	push   $0x76
  jmp alltraps
80105f71:	e9 24 f7 ff ff       	jmp    8010569a <alltraps>

80105f76 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $119
80105f78:	6a 77                	push   $0x77
  jmp alltraps
80105f7a:	e9 1b f7 ff ff       	jmp    8010569a <alltraps>

80105f7f <vector120>:
.globl vector120
vector120:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $120
80105f81:	6a 78                	push   $0x78
  jmp alltraps
80105f83:	e9 12 f7 ff ff       	jmp    8010569a <alltraps>

80105f88 <vector121>:
.globl vector121
vector121:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $121
80105f8a:	6a 79                	push   $0x79
  jmp alltraps
80105f8c:	e9 09 f7 ff ff       	jmp    8010569a <alltraps>

80105f91 <vector122>:
.globl vector122
vector122:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $122
80105f93:	6a 7a                	push   $0x7a
  jmp alltraps
80105f95:	e9 00 f7 ff ff       	jmp    8010569a <alltraps>

80105f9a <vector123>:
.globl vector123
vector123:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $123
80105f9c:	6a 7b                	push   $0x7b
  jmp alltraps
80105f9e:	e9 f7 f6 ff ff       	jmp    8010569a <alltraps>

80105fa3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $124
80105fa5:	6a 7c                	push   $0x7c
  jmp alltraps
80105fa7:	e9 ee f6 ff ff       	jmp    8010569a <alltraps>

80105fac <vector125>:
.globl vector125
vector125:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $125
80105fae:	6a 7d                	push   $0x7d
  jmp alltraps
80105fb0:	e9 e5 f6 ff ff       	jmp    8010569a <alltraps>

80105fb5 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $126
80105fb7:	6a 7e                	push   $0x7e
  jmp alltraps
80105fb9:	e9 dc f6 ff ff       	jmp    8010569a <alltraps>

80105fbe <vector127>:
.globl vector127
vector127:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $127
80105fc0:	6a 7f                	push   $0x7f
  jmp alltraps
80105fc2:	e9 d3 f6 ff ff       	jmp    8010569a <alltraps>

80105fc7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $128
80105fc9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105fce:	e9 c7 f6 ff ff       	jmp    8010569a <alltraps>

80105fd3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105fd3:	6a 00                	push   $0x0
  pushl $129
80105fd5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105fda:	e9 bb f6 ff ff       	jmp    8010569a <alltraps>

80105fdf <vector130>:
.globl vector130
vector130:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $130
80105fe1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105fe6:	e9 af f6 ff ff       	jmp    8010569a <alltraps>

80105feb <vector131>:
.globl vector131
vector131:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $131
80105fed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105ff2:	e9 a3 f6 ff ff       	jmp    8010569a <alltraps>

80105ff7 <vector132>:
.globl vector132
vector132:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $132
80105ff9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105ffe:	e9 97 f6 ff ff       	jmp    8010569a <alltraps>

80106003 <vector133>:
.globl vector133
vector133:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $133
80106005:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010600a:	e9 8b f6 ff ff       	jmp    8010569a <alltraps>

8010600f <vector134>:
.globl vector134
vector134:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $134
80106011:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106016:	e9 7f f6 ff ff       	jmp    8010569a <alltraps>

8010601b <vector135>:
.globl vector135
vector135:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $135
8010601d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106022:	e9 73 f6 ff ff       	jmp    8010569a <alltraps>

80106027 <vector136>:
.globl vector136
vector136:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $136
80106029:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010602e:	e9 67 f6 ff ff       	jmp    8010569a <alltraps>

80106033 <vector137>:
.globl vector137
vector137:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $137
80106035:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010603a:	e9 5b f6 ff ff       	jmp    8010569a <alltraps>

8010603f <vector138>:
.globl vector138
vector138:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $138
80106041:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106046:	e9 4f f6 ff ff       	jmp    8010569a <alltraps>

8010604b <vector139>:
.globl vector139
vector139:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $139
8010604d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106052:	e9 43 f6 ff ff       	jmp    8010569a <alltraps>

80106057 <vector140>:
.globl vector140
vector140:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $140
80106059:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010605e:	e9 37 f6 ff ff       	jmp    8010569a <alltraps>

80106063 <vector141>:
.globl vector141
vector141:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $141
80106065:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010606a:	e9 2b f6 ff ff       	jmp    8010569a <alltraps>

8010606f <vector142>:
.globl vector142
vector142:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $142
80106071:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106076:	e9 1f f6 ff ff       	jmp    8010569a <alltraps>

8010607b <vector143>:
.globl vector143
vector143:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $143
8010607d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106082:	e9 13 f6 ff ff       	jmp    8010569a <alltraps>

80106087 <vector144>:
.globl vector144
vector144:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $144
80106089:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010608e:	e9 07 f6 ff ff       	jmp    8010569a <alltraps>

80106093 <vector145>:
.globl vector145
vector145:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $145
80106095:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010609a:	e9 fb f5 ff ff       	jmp    8010569a <alltraps>

8010609f <vector146>:
.globl vector146
vector146:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $146
801060a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060a6:	e9 ef f5 ff ff       	jmp    8010569a <alltraps>

801060ab <vector147>:
.globl vector147
vector147:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $147
801060ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060b2:	e9 e3 f5 ff ff       	jmp    8010569a <alltraps>

801060b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $148
801060b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060be:	e9 d7 f5 ff ff       	jmp    8010569a <alltraps>

801060c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $149
801060c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060ca:	e9 cb f5 ff ff       	jmp    8010569a <alltraps>

801060cf <vector150>:
.globl vector150
vector150:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $150
801060d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060d6:	e9 bf f5 ff ff       	jmp    8010569a <alltraps>

801060db <vector151>:
.globl vector151
vector151:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $151
801060dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801060e2:	e9 b3 f5 ff ff       	jmp    8010569a <alltraps>

801060e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $152
801060e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801060ee:	e9 a7 f5 ff ff       	jmp    8010569a <alltraps>

801060f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $153
801060f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801060fa:	e9 9b f5 ff ff       	jmp    8010569a <alltraps>

801060ff <vector154>:
.globl vector154
vector154:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $154
80106101:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106106:	e9 8f f5 ff ff       	jmp    8010569a <alltraps>

8010610b <vector155>:
.globl vector155
vector155:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $155
8010610d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106112:	e9 83 f5 ff ff       	jmp    8010569a <alltraps>

80106117 <vector156>:
.globl vector156
vector156:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $156
80106119:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010611e:	e9 77 f5 ff ff       	jmp    8010569a <alltraps>

80106123 <vector157>:
.globl vector157
vector157:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $157
80106125:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010612a:	e9 6b f5 ff ff       	jmp    8010569a <alltraps>

8010612f <vector158>:
.globl vector158
vector158:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $158
80106131:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106136:	e9 5f f5 ff ff       	jmp    8010569a <alltraps>

8010613b <vector159>:
.globl vector159
vector159:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $159
8010613d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106142:	e9 53 f5 ff ff       	jmp    8010569a <alltraps>

80106147 <vector160>:
.globl vector160
vector160:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $160
80106149:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010614e:	e9 47 f5 ff ff       	jmp    8010569a <alltraps>

80106153 <vector161>:
.globl vector161
vector161:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $161
80106155:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010615a:	e9 3b f5 ff ff       	jmp    8010569a <alltraps>

8010615f <vector162>:
.globl vector162
vector162:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $162
80106161:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106166:	e9 2f f5 ff ff       	jmp    8010569a <alltraps>

8010616b <vector163>:
.globl vector163
vector163:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $163
8010616d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106172:	e9 23 f5 ff ff       	jmp    8010569a <alltraps>

80106177 <vector164>:
.globl vector164
vector164:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $164
80106179:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010617e:	e9 17 f5 ff ff       	jmp    8010569a <alltraps>

80106183 <vector165>:
.globl vector165
vector165:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $165
80106185:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010618a:	e9 0b f5 ff ff       	jmp    8010569a <alltraps>

8010618f <vector166>:
.globl vector166
vector166:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $166
80106191:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106196:	e9 ff f4 ff ff       	jmp    8010569a <alltraps>

8010619b <vector167>:
.globl vector167
vector167:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $167
8010619d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061a2:	e9 f3 f4 ff ff       	jmp    8010569a <alltraps>

801061a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $168
801061a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061ae:	e9 e7 f4 ff ff       	jmp    8010569a <alltraps>

801061b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $169
801061b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061ba:	e9 db f4 ff ff       	jmp    8010569a <alltraps>

801061bf <vector170>:
.globl vector170
vector170:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $170
801061c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061c6:	e9 cf f4 ff ff       	jmp    8010569a <alltraps>

801061cb <vector171>:
.globl vector171
vector171:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $171
801061cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061d2:	e9 c3 f4 ff ff       	jmp    8010569a <alltraps>

801061d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $172
801061d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061de:	e9 b7 f4 ff ff       	jmp    8010569a <alltraps>

801061e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $173
801061e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801061ea:	e9 ab f4 ff ff       	jmp    8010569a <alltraps>

801061ef <vector174>:
.globl vector174
vector174:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $174
801061f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801061f6:	e9 9f f4 ff ff       	jmp    8010569a <alltraps>

801061fb <vector175>:
.globl vector175
vector175:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $175
801061fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106202:	e9 93 f4 ff ff       	jmp    8010569a <alltraps>

80106207 <vector176>:
.globl vector176
vector176:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $176
80106209:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010620e:	e9 87 f4 ff ff       	jmp    8010569a <alltraps>

80106213 <vector177>:
.globl vector177
vector177:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $177
80106215:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010621a:	e9 7b f4 ff ff       	jmp    8010569a <alltraps>

8010621f <vector178>:
.globl vector178
vector178:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $178
80106221:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106226:	e9 6f f4 ff ff       	jmp    8010569a <alltraps>

8010622b <vector179>:
.globl vector179
vector179:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $179
8010622d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106232:	e9 63 f4 ff ff       	jmp    8010569a <alltraps>

80106237 <vector180>:
.globl vector180
vector180:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $180
80106239:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010623e:	e9 57 f4 ff ff       	jmp    8010569a <alltraps>

80106243 <vector181>:
.globl vector181
vector181:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $181
80106245:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010624a:	e9 4b f4 ff ff       	jmp    8010569a <alltraps>

8010624f <vector182>:
.globl vector182
vector182:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $182
80106251:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106256:	e9 3f f4 ff ff       	jmp    8010569a <alltraps>

8010625b <vector183>:
.globl vector183
vector183:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $183
8010625d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106262:	e9 33 f4 ff ff       	jmp    8010569a <alltraps>

80106267 <vector184>:
.globl vector184
vector184:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $184
80106269:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010626e:	e9 27 f4 ff ff       	jmp    8010569a <alltraps>

80106273 <vector185>:
.globl vector185
vector185:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $185
80106275:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010627a:	e9 1b f4 ff ff       	jmp    8010569a <alltraps>

8010627f <vector186>:
.globl vector186
vector186:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $186
80106281:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106286:	e9 0f f4 ff ff       	jmp    8010569a <alltraps>

8010628b <vector187>:
.globl vector187
vector187:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $187
8010628d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106292:	e9 03 f4 ff ff       	jmp    8010569a <alltraps>

80106297 <vector188>:
.globl vector188
vector188:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $188
80106299:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010629e:	e9 f7 f3 ff ff       	jmp    8010569a <alltraps>

801062a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $189
801062a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062aa:	e9 eb f3 ff ff       	jmp    8010569a <alltraps>

801062af <vector190>:
.globl vector190
vector190:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $190
801062b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062b6:	e9 df f3 ff ff       	jmp    8010569a <alltraps>

801062bb <vector191>:
.globl vector191
vector191:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $191
801062bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062c2:	e9 d3 f3 ff ff       	jmp    8010569a <alltraps>

801062c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $192
801062c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062ce:	e9 c7 f3 ff ff       	jmp    8010569a <alltraps>

801062d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $193
801062d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062da:	e9 bb f3 ff ff       	jmp    8010569a <alltraps>

801062df <vector194>:
.globl vector194
vector194:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $194
801062e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801062e6:	e9 af f3 ff ff       	jmp    8010569a <alltraps>

801062eb <vector195>:
.globl vector195
vector195:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $195
801062ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801062f2:	e9 a3 f3 ff ff       	jmp    8010569a <alltraps>

801062f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $196
801062f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801062fe:	e9 97 f3 ff ff       	jmp    8010569a <alltraps>

80106303 <vector197>:
.globl vector197
vector197:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $197
80106305:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010630a:	e9 8b f3 ff ff       	jmp    8010569a <alltraps>

8010630f <vector198>:
.globl vector198
vector198:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $198
80106311:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106316:	e9 7f f3 ff ff       	jmp    8010569a <alltraps>

8010631b <vector199>:
.globl vector199
vector199:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $199
8010631d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106322:	e9 73 f3 ff ff       	jmp    8010569a <alltraps>

80106327 <vector200>:
.globl vector200
vector200:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $200
80106329:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010632e:	e9 67 f3 ff ff       	jmp    8010569a <alltraps>

80106333 <vector201>:
.globl vector201
vector201:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $201
80106335:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010633a:	e9 5b f3 ff ff       	jmp    8010569a <alltraps>

8010633f <vector202>:
.globl vector202
vector202:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $202
80106341:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106346:	e9 4f f3 ff ff       	jmp    8010569a <alltraps>

8010634b <vector203>:
.globl vector203
vector203:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $203
8010634d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106352:	e9 43 f3 ff ff       	jmp    8010569a <alltraps>

80106357 <vector204>:
.globl vector204
vector204:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $204
80106359:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010635e:	e9 37 f3 ff ff       	jmp    8010569a <alltraps>

80106363 <vector205>:
.globl vector205
vector205:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $205
80106365:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010636a:	e9 2b f3 ff ff       	jmp    8010569a <alltraps>

8010636f <vector206>:
.globl vector206
vector206:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $206
80106371:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106376:	e9 1f f3 ff ff       	jmp    8010569a <alltraps>

8010637b <vector207>:
.globl vector207
vector207:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $207
8010637d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106382:	e9 13 f3 ff ff       	jmp    8010569a <alltraps>

80106387 <vector208>:
.globl vector208
vector208:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $208
80106389:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010638e:	e9 07 f3 ff ff       	jmp    8010569a <alltraps>

80106393 <vector209>:
.globl vector209
vector209:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $209
80106395:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010639a:	e9 fb f2 ff ff       	jmp    8010569a <alltraps>

8010639f <vector210>:
.globl vector210
vector210:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $210
801063a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063a6:	e9 ef f2 ff ff       	jmp    8010569a <alltraps>

801063ab <vector211>:
.globl vector211
vector211:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $211
801063ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063b2:	e9 e3 f2 ff ff       	jmp    8010569a <alltraps>

801063b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $212
801063b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063be:	e9 d7 f2 ff ff       	jmp    8010569a <alltraps>

801063c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $213
801063c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063ca:	e9 cb f2 ff ff       	jmp    8010569a <alltraps>

801063cf <vector214>:
.globl vector214
vector214:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $214
801063d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063d6:	e9 bf f2 ff ff       	jmp    8010569a <alltraps>

801063db <vector215>:
.globl vector215
vector215:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $215
801063dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801063e2:	e9 b3 f2 ff ff       	jmp    8010569a <alltraps>

801063e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $216
801063e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801063ee:	e9 a7 f2 ff ff       	jmp    8010569a <alltraps>

801063f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $217
801063f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801063fa:	e9 9b f2 ff ff       	jmp    8010569a <alltraps>

801063ff <vector218>:
.globl vector218
vector218:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $218
80106401:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106406:	e9 8f f2 ff ff       	jmp    8010569a <alltraps>

8010640b <vector219>:
.globl vector219
vector219:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $219
8010640d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106412:	e9 83 f2 ff ff       	jmp    8010569a <alltraps>

80106417 <vector220>:
.globl vector220
vector220:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $220
80106419:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010641e:	e9 77 f2 ff ff       	jmp    8010569a <alltraps>

80106423 <vector221>:
.globl vector221
vector221:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $221
80106425:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010642a:	e9 6b f2 ff ff       	jmp    8010569a <alltraps>

8010642f <vector222>:
.globl vector222
vector222:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $222
80106431:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106436:	e9 5f f2 ff ff       	jmp    8010569a <alltraps>

8010643b <vector223>:
.globl vector223
vector223:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $223
8010643d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106442:	e9 53 f2 ff ff       	jmp    8010569a <alltraps>

80106447 <vector224>:
.globl vector224
vector224:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $224
80106449:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010644e:	e9 47 f2 ff ff       	jmp    8010569a <alltraps>

80106453 <vector225>:
.globl vector225
vector225:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $225
80106455:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010645a:	e9 3b f2 ff ff       	jmp    8010569a <alltraps>

8010645f <vector226>:
.globl vector226
vector226:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $226
80106461:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106466:	e9 2f f2 ff ff       	jmp    8010569a <alltraps>

8010646b <vector227>:
.globl vector227
vector227:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $227
8010646d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106472:	e9 23 f2 ff ff       	jmp    8010569a <alltraps>

80106477 <vector228>:
.globl vector228
vector228:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $228
80106479:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010647e:	e9 17 f2 ff ff       	jmp    8010569a <alltraps>

80106483 <vector229>:
.globl vector229
vector229:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $229
80106485:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010648a:	e9 0b f2 ff ff       	jmp    8010569a <alltraps>

8010648f <vector230>:
.globl vector230
vector230:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $230
80106491:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106496:	e9 ff f1 ff ff       	jmp    8010569a <alltraps>

8010649b <vector231>:
.globl vector231
vector231:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $231
8010649d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064a2:	e9 f3 f1 ff ff       	jmp    8010569a <alltraps>

801064a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $232
801064a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064ae:	e9 e7 f1 ff ff       	jmp    8010569a <alltraps>

801064b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $233
801064b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064ba:	e9 db f1 ff ff       	jmp    8010569a <alltraps>

801064bf <vector234>:
.globl vector234
vector234:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $234
801064c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064c6:	e9 cf f1 ff ff       	jmp    8010569a <alltraps>

801064cb <vector235>:
.globl vector235
vector235:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $235
801064cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064d2:	e9 c3 f1 ff ff       	jmp    8010569a <alltraps>

801064d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $236
801064d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064de:	e9 b7 f1 ff ff       	jmp    8010569a <alltraps>

801064e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $237
801064e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801064ea:	e9 ab f1 ff ff       	jmp    8010569a <alltraps>

801064ef <vector238>:
.globl vector238
vector238:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $238
801064f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801064f6:	e9 9f f1 ff ff       	jmp    8010569a <alltraps>

801064fb <vector239>:
.globl vector239
vector239:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $239
801064fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106502:	e9 93 f1 ff ff       	jmp    8010569a <alltraps>

80106507 <vector240>:
.globl vector240
vector240:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $240
80106509:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010650e:	e9 87 f1 ff ff       	jmp    8010569a <alltraps>

80106513 <vector241>:
.globl vector241
vector241:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $241
80106515:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010651a:	e9 7b f1 ff ff       	jmp    8010569a <alltraps>

8010651f <vector242>:
.globl vector242
vector242:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $242
80106521:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106526:	e9 6f f1 ff ff       	jmp    8010569a <alltraps>

8010652b <vector243>:
.globl vector243
vector243:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $243
8010652d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106532:	e9 63 f1 ff ff       	jmp    8010569a <alltraps>

80106537 <vector244>:
.globl vector244
vector244:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $244
80106539:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010653e:	e9 57 f1 ff ff       	jmp    8010569a <alltraps>

80106543 <vector245>:
.globl vector245
vector245:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $245
80106545:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010654a:	e9 4b f1 ff ff       	jmp    8010569a <alltraps>

8010654f <vector246>:
.globl vector246
vector246:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $246
80106551:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106556:	e9 3f f1 ff ff       	jmp    8010569a <alltraps>

8010655b <vector247>:
.globl vector247
vector247:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $247
8010655d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106562:	e9 33 f1 ff ff       	jmp    8010569a <alltraps>

80106567 <vector248>:
.globl vector248
vector248:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $248
80106569:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010656e:	e9 27 f1 ff ff       	jmp    8010569a <alltraps>

80106573 <vector249>:
.globl vector249
vector249:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $249
80106575:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010657a:	e9 1b f1 ff ff       	jmp    8010569a <alltraps>

8010657f <vector250>:
.globl vector250
vector250:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $250
80106581:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106586:	e9 0f f1 ff ff       	jmp    8010569a <alltraps>

8010658b <vector251>:
.globl vector251
vector251:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $251
8010658d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106592:	e9 03 f1 ff ff       	jmp    8010569a <alltraps>

80106597 <vector252>:
.globl vector252
vector252:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $252
80106599:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010659e:	e9 f7 f0 ff ff       	jmp    8010569a <alltraps>

801065a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $253
801065a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065aa:	e9 eb f0 ff ff       	jmp    8010569a <alltraps>

801065af <vector254>:
.globl vector254
vector254:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $254
801065b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065b6:	e9 df f0 ff ff       	jmp    8010569a <alltraps>

801065bb <vector255>:
.globl vector255
vector255:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $255
801065bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065c2:	e9 d3 f0 ff ff       	jmp    8010569a <alltraps>
801065c7:	66 90                	xchg   %ax,%ax
801065c9:	66 90                	xchg   %ax,%ax
801065cb:	66 90                	xchg   %ax,%ax
801065cd:	66 90                	xchg   %ax,%ax
801065cf:	90                   	nop

801065d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	57                   	push   %edi
801065d4:	56                   	push   %esi
801065d5:	53                   	push   %ebx
801065d6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065d8:	c1 ea 16             	shr    $0x16,%edx
801065db:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065de:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801065e1:	8b 07                	mov    (%edi),%eax
801065e3:	a8 01                	test   $0x1,%al
801065e5:	74 29                	je     80106610 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801065e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801065ec:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801065f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801065f5:	c1 eb 0a             	shr    $0xa,%ebx
801065f8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801065fe:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106601:	5b                   	pop    %ebx
80106602:	5e                   	pop    %esi
80106603:	5f                   	pop    %edi
80106604:	5d                   	pop    %ebp
80106605:	c3                   	ret    
80106606:	8d 76 00             	lea    0x0(%esi),%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106610:	85 c9                	test   %ecx,%ecx
80106612:	74 2c                	je     80106640 <walkpgdir+0x70>
80106614:	e8 f7 be ff ff       	call   80102510 <kalloc>
80106619:	85 c0                	test   %eax,%eax
8010661b:	89 c6                	mov    %eax,%esi
8010661d:	74 21                	je     80106640 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010661f:	83 ec 04             	sub    $0x4,%esp
80106622:	68 00 10 00 00       	push   $0x1000
80106627:	6a 00                	push   $0x0
80106629:	50                   	push   %eax
8010662a:	e8 71 de ff ff       	call   801044a0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010662f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106635:	83 c4 10             	add    $0x10,%esp
80106638:	83 c8 07             	or     $0x7,%eax
8010663b:	89 07                	mov    %eax,(%edi)
8010663d:	eb b3                	jmp    801065f2 <walkpgdir+0x22>
8010663f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106643:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106645:	5b                   	pop    %ebx
80106646:	5e                   	pop    %esi
80106647:	5f                   	pop    %edi
80106648:	5d                   	pop    %ebp
80106649:	c3                   	ret    
8010664a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106650 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	57                   	push   %edi
80106654:	56                   	push   %esi
80106655:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106656:	89 d3                	mov    %edx,%ebx
80106658:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010665e:	83 ec 1c             	sub    $0x1c,%esp
80106661:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106664:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106668:	8b 7d 08             	mov    0x8(%ebp),%edi
8010666b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106673:	8b 45 0c             	mov    0xc(%ebp),%eax
80106676:	29 df                	sub    %ebx,%edi
80106678:	83 c8 01             	or     $0x1,%eax
8010667b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010667e:	eb 15                	jmp    80106695 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106680:	f6 00 01             	testb  $0x1,(%eax)
80106683:	75 45                	jne    801066ca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106685:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106688:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010668b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010668d:	74 31                	je     801066c0 <mappages+0x70>
      break;
    a += PGSIZE;
8010668f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106698:	b9 01 00 00 00       	mov    $0x1,%ecx
8010669d:	89 da                	mov    %ebx,%edx
8010669f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801066a2:	e8 29 ff ff ff       	call   801065d0 <walkpgdir>
801066a7:	85 c0                	test   %eax,%eax
801066a9:	75 d5                	jne    80106680 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801066ab:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801066ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801066b3:	5b                   	pop    %ebx
801066b4:	5e                   	pop    %esi
801066b5:	5f                   	pop    %edi
801066b6:	5d                   	pop    %ebp
801066b7:	c3                   	ret    
801066b8:	90                   	nop
801066b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801066c3:	31 c0                	xor    %eax,%eax
}
801066c5:	5b                   	pop    %ebx
801066c6:	5e                   	pop    %esi
801066c7:	5f                   	pop    %edi
801066c8:	5d                   	pop    %ebp
801066c9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801066ca:	83 ec 0c             	sub    $0xc,%esp
801066cd:	68 28 78 10 80       	push   $0x80107828
801066d2:	e8 99 9c ff ff       	call   80100370 <panic>
801066d7:	89 f6                	mov    %esi,%esi
801066d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066e0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	56                   	push   %esi
801066e5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066e6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066ec:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066f4:	83 ec 1c             	sub    $0x1c,%esp
801066f7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066fa:	39 d3                	cmp    %edx,%ebx
801066fc:	73 66                	jae    80106764 <deallocuvm.part.0+0x84>
801066fe:	89 d6                	mov    %edx,%esi
80106700:	eb 3d                	jmp    8010673f <deallocuvm.part.0+0x5f>
80106702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106708:	8b 10                	mov    (%eax),%edx
8010670a:	f6 c2 01             	test   $0x1,%dl
8010670d:	74 26                	je     80106735 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010670f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106715:	74 58                	je     8010676f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106717:	83 ec 0c             	sub    $0xc,%esp
8010671a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106723:	52                   	push   %edx
80106724:	e8 37 bc ff ff       	call   80102360 <kfree>
      *pte = 0;
80106729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010672c:	83 c4 10             	add    $0x10,%esp
8010672f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106735:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010673b:	39 f3                	cmp    %esi,%ebx
8010673d:	73 25                	jae    80106764 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010673f:	31 c9                	xor    %ecx,%ecx
80106741:	89 da                	mov    %ebx,%edx
80106743:	89 f8                	mov    %edi,%eax
80106745:	e8 86 fe ff ff       	call   801065d0 <walkpgdir>
    if(!pte)
8010674a:	85 c0                	test   %eax,%eax
8010674c:	75 ba                	jne    80106708 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010674e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106754:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010675a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106760:	39 f3                	cmp    %esi,%ebx
80106762:	72 db                	jb     8010673f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106764:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106767:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010676a:	5b                   	pop    %ebx
8010676b:	5e                   	pop    %esi
8010676c:	5f                   	pop    %edi
8010676d:	5d                   	pop    %ebp
8010676e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010676f:	83 ec 0c             	sub    $0xc,%esp
80106772:	68 c6 71 10 80       	push   $0x801071c6
80106777:	e8 f4 9b ff ff       	call   80100370 <panic>
8010677c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106780 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106786:	e8 55 d0 ff ff       	call   801037e0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010678b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106791:	31 c9                	xor    %ecx,%ecx
80106793:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106798:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
8010679f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067a6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067ab:	31 c9                	xor    %ecx,%ecx
801067ad:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067b4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067b9:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067c0:	31 c9                	xor    %ecx,%ecx
801067c2:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
801067c9:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067d0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067d5:	31 c9                	xor    %ecx,%ecx
801067d7:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067de:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801067e5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801067ea:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
801067f1:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
801067f8:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067ff:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106806:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
8010680d:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80106814:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010681b:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106822:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106829:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106830:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106837:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
8010683e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106845:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
8010684c:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106853:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010685a:	05 f0 27 11 80       	add    $0x801127f0,%eax
8010685f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106863:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106867:	c1 e8 10             	shr    $0x10,%eax
8010686a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010686e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106871:	0f 01 10             	lgdtl  (%eax)
}
80106874:	c9                   	leave  
80106875:	c3                   	ret    
80106876:	8d 76 00             	lea    0x0(%esi),%esi
80106879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106880 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106880:	a1 a4 54 11 80       	mov    0x801154a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106885:	55                   	push   %ebp
80106886:	89 e5                	mov    %esp,%ebp
80106888:	05 00 00 00 80       	add    $0x80000000,%eax
8010688d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106890:	5d                   	pop    %ebp
80106891:	c3                   	ret    
80106892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068a0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	57                   	push   %edi
801068a4:	56                   	push   %esi
801068a5:	53                   	push   %ebx
801068a6:	83 ec 1c             	sub    $0x1c,%esp
801068a9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801068ac:	85 f6                	test   %esi,%esi
801068ae:	0f 84 cd 00 00 00    	je     80106981 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801068b4:	8b 46 08             	mov    0x8(%esi),%eax
801068b7:	85 c0                	test   %eax,%eax
801068b9:	0f 84 dc 00 00 00    	je     8010699b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801068bf:	8b 7e 04             	mov    0x4(%esi),%edi
801068c2:	85 ff                	test   %edi,%edi
801068c4:	0f 84 c4 00 00 00    	je     8010698e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801068ca:	e8 f1 d9 ff ff       	call   801042c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068cf:	e8 8c ce ff ff       	call   80103760 <mycpu>
801068d4:	89 c3                	mov    %eax,%ebx
801068d6:	e8 85 ce ff ff       	call   80103760 <mycpu>
801068db:	89 c7                	mov    %eax,%edi
801068dd:	e8 7e ce ff ff       	call   80103760 <mycpu>
801068e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068e5:	83 c7 08             	add    $0x8,%edi
801068e8:	e8 73 ce ff ff       	call   80103760 <mycpu>
801068ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801068f0:	83 c0 08             	add    $0x8,%eax
801068f3:	ba 67 00 00 00       	mov    $0x67,%edx
801068f8:	c1 e8 18             	shr    $0x18,%eax
801068fb:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106902:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106909:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106910:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106917:	83 c1 08             	add    $0x8,%ecx
8010691a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106920:	c1 e9 10             	shr    $0x10,%ecx
80106923:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106929:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010692e:	e8 2d ce ff ff       	call   80103760 <mycpu>
80106933:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010693a:	e8 21 ce ff ff       	call   80103760 <mycpu>
8010693f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106944:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106948:	e8 13 ce ff ff       	call   80103760 <mycpu>
8010694d:	8b 56 08             	mov    0x8(%esi),%edx
80106950:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106956:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106959:	e8 02 ce ff ff       	call   80103760 <mycpu>
8010695e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106962:	b8 28 00 00 00       	mov    $0x28,%eax
80106967:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010696a:	8b 46 04             	mov    0x4(%esi),%eax
8010696d:	05 00 00 00 80       	add    $0x80000000,%eax
80106972:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106975:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106978:	5b                   	pop    %ebx
80106979:	5e                   	pop    %esi
8010697a:	5f                   	pop    %edi
8010697b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010697c:	e9 7f d9 ff ff       	jmp    80104300 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106981:	83 ec 0c             	sub    $0xc,%esp
80106984:	68 2e 78 10 80       	push   $0x8010782e
80106989:	e8 e2 99 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010698e:	83 ec 0c             	sub    $0xc,%esp
80106991:	68 59 78 10 80       	push   $0x80107859
80106996:	e8 d5 99 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010699b:	83 ec 0c             	sub    $0xc,%esp
8010699e:	68 44 78 10 80       	push   $0x80107844
801069a3:	e8 c8 99 ff ff       	call   80100370 <panic>
801069a8:	90                   	nop
801069a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069b0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
801069b6:	83 ec 1c             	sub    $0x1c,%esp
801069b9:	8b 75 10             	mov    0x10(%ebp),%esi
801069bc:	8b 45 08             	mov    0x8(%ebp),%eax
801069bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801069c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801069cb:	77 49                	ja     80106a16 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801069cd:	e8 3e bb ff ff       	call   80102510 <kalloc>
  memset(mem, 0, PGSIZE);
801069d2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801069d5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801069d7:	68 00 10 00 00       	push   $0x1000
801069dc:	6a 00                	push   $0x0
801069de:	50                   	push   %eax
801069df:	e8 bc da ff ff       	call   801044a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801069e4:	58                   	pop    %eax
801069e5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801069f0:	5a                   	pop    %edx
801069f1:	6a 06                	push   $0x6
801069f3:	50                   	push   %eax
801069f4:	31 d2                	xor    %edx,%edx
801069f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069f9:	e8 52 fc ff ff       	call   80106650 <mappages>
  memmove(mem, init, sz);
801069fe:	89 75 10             	mov    %esi,0x10(%ebp)
80106a01:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a04:	83 c4 10             	add    $0x10,%esp
80106a07:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a0d:	5b                   	pop    %ebx
80106a0e:	5e                   	pop    %esi
80106a0f:	5f                   	pop    %edi
80106a10:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a11:	e9 3a db ff ff       	jmp    80104550 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a16:	83 ec 0c             	sub    $0xc,%esp
80106a19:	68 6d 78 10 80       	push   $0x8010786d
80106a1e:	e8 4d 99 ff ff       	call   80100370 <panic>
80106a23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a30 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
80106a35:	53                   	push   %ebx
80106a36:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106a39:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a40:	0f 85 91 00 00 00    	jne    80106ad7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106a46:	8b 75 18             	mov    0x18(%ebp),%esi
80106a49:	31 db                	xor    %ebx,%ebx
80106a4b:	85 f6                	test   %esi,%esi
80106a4d:	75 1a                	jne    80106a69 <loaduvm+0x39>
80106a4f:	eb 6f                	jmp    80106ac0 <loaduvm+0x90>
80106a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a58:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a5e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a64:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a67:	76 57                	jbe    80106ac0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a69:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a6f:	31 c9                	xor    %ecx,%ecx
80106a71:	01 da                	add    %ebx,%edx
80106a73:	e8 58 fb ff ff       	call   801065d0 <walkpgdir>
80106a78:	85 c0                	test   %eax,%eax
80106a7a:	74 4e                	je     80106aca <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a7c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a7e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106a81:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106a8b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a91:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a94:	01 d9                	add    %ebx,%ecx
80106a96:	05 00 00 00 80       	add    $0x80000000,%eax
80106a9b:	57                   	push   %edi
80106a9c:	51                   	push   %ecx
80106a9d:	50                   	push   %eax
80106a9e:	ff 75 10             	pushl  0x10(%ebp)
80106aa1:	e8 2a af ff ff       	call   801019d0 <readi>
80106aa6:	83 c4 10             	add    $0x10,%esp
80106aa9:	39 c7                	cmp    %eax,%edi
80106aab:	74 ab                	je     80106a58 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106aad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ab5:	5b                   	pop    %ebx
80106ab6:	5e                   	pop    %esi
80106ab7:	5f                   	pop    %edi
80106ab8:	5d                   	pop    %ebp
80106ab9:	c3                   	ret    
80106aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106ac3:	31 c0                	xor    %eax,%eax
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106aca:	83 ec 0c             	sub    $0xc,%esp
80106acd:	68 87 78 10 80       	push   $0x80107887
80106ad2:	e8 99 98 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106ad7:	83 ec 0c             	sub    $0xc,%esp
80106ada:	68 28 79 10 80       	push   $0x80107928
80106adf:	e8 8c 98 ff ff       	call   80100370 <panic>
80106ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106af0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
80106af6:	83 ec 0c             	sub    $0xc,%esp
80106af9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106afc:	85 ff                	test   %edi,%edi
80106afe:	0f 88 ca 00 00 00    	js     80106bce <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106b04:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106b0a:	0f 82 82 00 00 00    	jb     80106b92 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b10:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b16:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b1c:	39 df                	cmp    %ebx,%edi
80106b1e:	77 43                	ja     80106b63 <allocuvm+0x73>
80106b20:	e9 bb 00 00 00       	jmp    80106be0 <allocuvm+0xf0>
80106b25:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b28:	83 ec 04             	sub    $0x4,%esp
80106b2b:	68 00 10 00 00       	push   $0x1000
80106b30:	6a 00                	push   $0x0
80106b32:	50                   	push   %eax
80106b33:	e8 68 d9 ff ff       	call   801044a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b38:	58                   	pop    %eax
80106b39:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b3f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b44:	5a                   	pop    %edx
80106b45:	6a 06                	push   $0x6
80106b47:	50                   	push   %eax
80106b48:	89 da                	mov    %ebx,%edx
80106b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80106b4d:	e8 fe fa ff ff       	call   80106650 <mappages>
80106b52:	83 c4 10             	add    $0x10,%esp
80106b55:	85 c0                	test   %eax,%eax
80106b57:	78 47                	js     80106ba0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106b59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b5f:	39 df                	cmp    %ebx,%edi
80106b61:	76 7d                	jbe    80106be0 <allocuvm+0xf0>
    mem = kalloc();
80106b63:	e8 a8 b9 ff ff       	call   80102510 <kalloc>
    if(mem == 0){
80106b68:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106b6a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106b6c:	75 ba                	jne    80106b28 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106b6e:	83 ec 0c             	sub    $0xc,%esp
80106b71:	68 a5 78 10 80       	push   $0x801078a5
80106b76:	e8 e5 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b7b:	83 c4 10             	add    $0x10,%esp
80106b7e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b81:	76 4b                	jbe    80106bce <allocuvm+0xde>
80106b83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b86:	8b 45 08             	mov    0x8(%ebp),%eax
80106b89:	89 fa                	mov    %edi,%edx
80106b8b:	e8 50 fb ff ff       	call   801066e0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106b90:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b95:	5b                   	pop    %ebx
80106b96:	5e                   	pop    %esi
80106b97:	5f                   	pop    %edi
80106b98:	5d                   	pop    %ebp
80106b99:	c3                   	ret    
80106b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106ba0:	83 ec 0c             	sub    $0xc,%esp
80106ba3:	68 bd 78 10 80       	push   $0x801078bd
80106ba8:	e8 b3 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bad:	83 c4 10             	add    $0x10,%esp
80106bb0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bb3:	76 0d                	jbe    80106bc2 <allocuvm+0xd2>
80106bb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bbb:	89 fa                	mov    %edi,%edx
80106bbd:	e8 1e fb ff ff       	call   801066e0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106bc2:	83 ec 0c             	sub    $0xc,%esp
80106bc5:	56                   	push   %esi
80106bc6:	e8 95 b7 ff ff       	call   80102360 <kfree>
      return 0;
80106bcb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106bd1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106bd3:	5b                   	pop    %ebx
80106bd4:	5e                   	pop    %esi
80106bd5:	5f                   	pop    %edi
80106bd6:	5d                   	pop    %ebp
80106bd7:	c3                   	ret    
80106bd8:	90                   	nop
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106be3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
80106bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bf0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bfc:	39 d1                	cmp    %edx,%ecx
80106bfe:	73 10                	jae    80106c10 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c00:	5d                   	pop    %ebp
80106c01:	e9 da fa ff ff       	jmp    801066e0 <deallocuvm.part.0>
80106c06:	8d 76 00             	lea    0x0(%esi),%esi
80106c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c10:	89 d0                	mov    %edx,%eax
80106c12:	5d                   	pop    %ebp
80106c13:	c3                   	ret    
80106c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 0c             	sub    $0xc,%esp
80106c29:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c2c:	85 f6                	test   %esi,%esi
80106c2e:	74 59                	je     80106c89 <freevm+0x69>
80106c30:	31 c9                	xor    %ecx,%ecx
80106c32:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c37:	89 f0                	mov    %esi,%eax
80106c39:	e8 a2 fa ff ff       	call   801066e0 <deallocuvm.part.0>
80106c3e:	89 f3                	mov    %esi,%ebx
80106c40:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106c46:	eb 0f                	jmp    80106c57 <freevm+0x37>
80106c48:	90                   	nop
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c50:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c53:	39 fb                	cmp    %edi,%ebx
80106c55:	74 23                	je     80106c7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106c57:	8b 03                	mov    (%ebx),%eax
80106c59:	a8 01                	test   $0x1,%al
80106c5b:	74 f3                	je     80106c50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106c5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c62:	83 ec 0c             	sub    $0xc,%esp
80106c65:	83 c3 04             	add    $0x4,%ebx
80106c68:	05 00 00 00 80       	add    $0x80000000,%eax
80106c6d:	50                   	push   %eax
80106c6e:	e8 ed b6 ff ff       	call   80102360 <kfree>
80106c73:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c76:	39 fb                	cmp    %edi,%ebx
80106c78:	75 dd                	jne    80106c57 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106c7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c80:	5b                   	pop    %ebx
80106c81:	5e                   	pop    %esi
80106c82:	5f                   	pop    %edi
80106c83:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106c84:	e9 d7 b6 ff ff       	jmp    80102360 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106c89:	83 ec 0c             	sub    $0xc,%esp
80106c8c:	68 d9 78 10 80       	push   $0x801078d9
80106c91:	e8 da 96 ff ff       	call   80100370 <panic>
80106c96:	8d 76 00             	lea    0x0(%esi),%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	56                   	push   %esi
80106ca4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106ca5:	e8 66 b8 ff ff       	call   80102510 <kalloc>
80106caa:	85 c0                	test   %eax,%eax
80106cac:	74 6a                	je     80106d18 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106cae:	83 ec 04             	sub    $0x4,%esp
80106cb1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106cb3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106cb8:	68 00 10 00 00       	push   $0x1000
80106cbd:	6a 00                	push   $0x0
80106cbf:	50                   	push   %eax
80106cc0:	e8 db d7 ff ff       	call   801044a0 <memset>
80106cc5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106cc8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ccb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106cce:	83 ec 08             	sub    $0x8,%esp
80106cd1:	8b 13                	mov    (%ebx),%edx
80106cd3:	ff 73 0c             	pushl  0xc(%ebx)
80106cd6:	50                   	push   %eax
80106cd7:	29 c1                	sub    %eax,%ecx
80106cd9:	89 f0                	mov    %esi,%eax
80106cdb:	e8 70 f9 ff ff       	call   80106650 <mappages>
80106ce0:	83 c4 10             	add    $0x10,%esp
80106ce3:	85 c0                	test   %eax,%eax
80106ce5:	78 19                	js     80106d00 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ce7:	83 c3 10             	add    $0x10,%ebx
80106cea:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106cf0:	75 d6                	jne    80106cc8 <setupkvm+0x28>
80106cf2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106cf7:	5b                   	pop    %ebx
80106cf8:	5e                   	pop    %esi
80106cf9:	5d                   	pop    %ebp
80106cfa:	c3                   	ret    
80106cfb:	90                   	nop
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106d00:	83 ec 0c             	sub    $0xc,%esp
80106d03:	56                   	push   %esi
80106d04:	e8 17 ff ff ff       	call   80106c20 <freevm>
      return 0;
80106d09:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106d0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106d0f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106d11:	5b                   	pop    %ebx
80106d12:	5e                   	pop    %esi
80106d13:	5d                   	pop    %ebp
80106d14:	c3                   	ret    
80106d15:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106d18:	31 c0                	xor    %eax,%eax
80106d1a:	eb d8                	jmp    80106cf4 <setupkvm+0x54>
80106d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d20 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d26:	e8 75 ff ff ff       	call   80106ca0 <setupkvm>
80106d2b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
80106d30:	05 00 00 00 80       	add    $0x80000000,%eax
80106d35:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106d38:	c9                   	leave  
80106d39:	c3                   	ret    
80106d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d41:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d43:	89 e5                	mov    %esp,%ebp
80106d45:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4e:	e8 7d f8 ff ff       	call   801065d0 <walkpgdir>
  if(pte == 0)
80106d53:	85 c0                	test   %eax,%eax
80106d55:	74 05                	je     80106d5c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106d57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106d5a:	c9                   	leave  
80106d5b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106d5c:	83 ec 0c             	sub    $0xc,%esp
80106d5f:	68 ea 78 10 80       	push   $0x801078ea
80106d64:	e8 07 96 ff ff       	call   80100370 <panic>
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106d79:	e8 22 ff ff ff       	call   80106ca0 <setupkvm>
80106d7e:	85 c0                	test   %eax,%eax
80106d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d83:	0f 84 c5 00 00 00    	je     80106e4e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d8c:	85 c9                	test   %ecx,%ecx
80106d8e:	0f 84 9c 00 00 00    	je     80106e30 <copyuvm+0xc0>
80106d94:	31 ff                	xor    %edi,%edi
80106d96:	eb 4a                	jmp    80106de2 <copyuvm+0x72>
80106d98:	90                   	nop
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106da0:	83 ec 04             	sub    $0x4,%esp
80106da3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106da9:	68 00 10 00 00       	push   $0x1000
80106dae:	53                   	push   %ebx
80106daf:	50                   	push   %eax
80106db0:	e8 9b d7 ff ff       	call   80104550 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106db5:	58                   	pop    %eax
80106db6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106dbc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dc1:	5a                   	pop    %edx
80106dc2:	ff 75 e4             	pushl  -0x1c(%ebp)
80106dc5:	50                   	push   %eax
80106dc6:	89 fa                	mov    %edi,%edx
80106dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106dcb:	e8 80 f8 ff ff       	call   80106650 <mappages>
80106dd0:	83 c4 10             	add    $0x10,%esp
80106dd3:	85 c0                	test   %eax,%eax
80106dd5:	78 69                	js     80106e40 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106dd7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ddd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106de0:	76 4e                	jbe    80106e30 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106de2:	8b 45 08             	mov    0x8(%ebp),%eax
80106de5:	31 c9                	xor    %ecx,%ecx
80106de7:	89 fa                	mov    %edi,%edx
80106de9:	e8 e2 f7 ff ff       	call   801065d0 <walkpgdir>
80106dee:	85 c0                	test   %eax,%eax
80106df0:	74 6d                	je     80106e5f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106df2:	8b 00                	mov    (%eax),%eax
80106df4:	a8 01                	test   $0x1,%al
80106df6:	74 5a                	je     80106e52 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106df8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106dfa:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106dff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106e08:	e8 03 b7 ff ff       	call   80102510 <kalloc>
80106e0d:	85 c0                	test   %eax,%eax
80106e0f:	89 c6                	mov    %eax,%esi
80106e11:	75 8d                	jne    80106da0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106e13:	83 ec 0c             	sub    $0xc,%esp
80106e16:	ff 75 e0             	pushl  -0x20(%ebp)
80106e19:	e8 02 fe ff ff       	call   80106c20 <freevm>
  return 0;
80106e1e:	83 c4 10             	add    $0x10,%esp
80106e21:	31 c0                	xor    %eax,%eax
}
80106e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e26:	5b                   	pop    %ebx
80106e27:	5e                   	pop    %esi
80106e28:	5f                   	pop    %edi
80106e29:	5d                   	pop    %ebp
80106e2a:	c3                   	ret    
80106e2b:	90                   	nop
80106e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e36:	5b                   	pop    %ebx
80106e37:	5e                   	pop    %esi
80106e38:	5f                   	pop    %edi
80106e39:	5d                   	pop    %ebp
80106e3a:	c3                   	ret    
80106e3b:	90                   	nop
80106e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80106e40:	83 ec 0c             	sub    $0xc,%esp
80106e43:	56                   	push   %esi
80106e44:	e8 17 b5 ff ff       	call   80102360 <kfree>
      goto bad;
80106e49:	83 c4 10             	add    $0x10,%esp
80106e4c:	eb c5                	jmp    80106e13 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106e4e:	31 c0                	xor    %eax,%eax
80106e50:	eb d1                	jmp    80106e23 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106e52:	83 ec 0c             	sub    $0xc,%esp
80106e55:	68 0e 79 10 80       	push   $0x8010790e
80106e5a:	e8 11 95 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106e5f:	83 ec 0c             	sub    $0xc,%esp
80106e62:	68 f4 78 10 80       	push   $0x801078f4
80106e67:	e8 04 95 ff ff       	call   80100370 <panic>
80106e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e71:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e73:	89 e5                	mov    %esp,%ebp
80106e75:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7e:	e8 4d f7 ff ff       	call   801065d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106e83:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106e85:	89 c2                	mov    %eax,%edx
80106e87:	83 e2 05             	and    $0x5,%edx
80106e8a:	83 fa 05             	cmp    $0x5,%edx
80106e8d:	75 11                	jne    80106ea0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106e8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106e94:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106e95:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106e9a:	c3                   	ret    
80106e9b:	90                   	nop
80106e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106ea0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106ea2:	c9                   	leave  
80106ea3:	c3                   	ret    
80106ea4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106eb0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
80106eb6:	83 ec 1c             	sub    $0x1c,%esp
80106eb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ebf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ec2:	85 db                	test   %ebx,%ebx
80106ec4:	75 40                	jne    80106f06 <copyout+0x56>
80106ec6:	eb 70                	jmp    80106f38 <copyout+0x88>
80106ec8:	90                   	nop
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ed3:	89 f1                	mov    %esi,%ecx
80106ed5:	29 d1                	sub    %edx,%ecx
80106ed7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106edd:	39 d9                	cmp    %ebx,%ecx
80106edf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ee2:	29 f2                	sub    %esi,%edx
80106ee4:	83 ec 04             	sub    $0x4,%esp
80106ee7:	01 d0                	add    %edx,%eax
80106ee9:	51                   	push   %ecx
80106eea:	57                   	push   %edi
80106eeb:	50                   	push   %eax
80106eec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106eef:	e8 5c d6 ff ff       	call   80104550 <memmove>
    len -= n;
    buf += n;
80106ef4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ef7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106efa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106f00:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f02:	29 cb                	sub    %ecx,%ebx
80106f04:	74 32                	je     80106f38 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f06:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f08:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106f0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f0e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f14:	56                   	push   %esi
80106f15:	ff 75 08             	pushl  0x8(%ebp)
80106f18:	e8 53 ff ff ff       	call   80106e70 <uva2ka>
    if(pa0 == 0)
80106f1d:	83 c4 10             	add    $0x10,%esp
80106f20:	85 c0                	test   %eax,%eax
80106f22:	75 ac                	jne    80106ed0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f2c:	5b                   	pop    %ebx
80106f2d:	5e                   	pop    %esi
80106f2e:	5f                   	pop    %edi
80106f2f:	5d                   	pop    %ebp
80106f30:	c3                   	ret    
80106f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106f3b:	31 c0                	xor    %eax,%eax
}
80106f3d:	5b                   	pop    %ebx
80106f3e:	5e                   	pop    %esi
80106f3f:	5f                   	pop    %edi
80106f40:	5d                   	pop    %ebp
80106f41:	c3                   	ret    
