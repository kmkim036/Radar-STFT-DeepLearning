class CircularQueue:
    # circular queue to save radar raw data
    def __init__(self):
        self.front = 0
        self.rear = 0
        self.max_qsize = 1921   # 16 * 8 * 15 + 1
        self.items = [None] * self.max_qsize

    def isEmpty(self):
        return self.front == self.rear

    def isFull(self):
        return self.front == (self.rear+1) % self.max_qsize

    def clear(self):
        self.front = self.rear

    def __len__(self):
        return (self.rear - self.front + self.max_qsize) % self.max_qsize

    def enqueue(self, item):
        if not self.isFull():
            self.rear = (self.rear + 1) % self.max_qsize
            self.items[self.rear] = item

    def dequeue(self):
        if not self.isEmpty():
            self.front = (self.front+1) % self.max_qsize
            return self.items[self.front]

    def peek(self):
        if not self.isEmpty():
            return self.items[(self.front+1) % self.max_qsize]

    def print(self):
        out = []
        if self.front < self.rear:
            out = self.items[self.front+1:self.rear+1]
        else:
            out = self.items[self.front+1:self.max_qsize] + \
                self.items[0:self.rear+1]

        print("[f=%s, r=%d] ==> " % (self.front, self.rear), out)

    def returndata(self):
        result = []
        if self.front < self.rear:
            result = self.items[self.front+1:self.rear+1]
        else:
            result = self.items[self.front+1:self.max_qsize] + \
                self.items[0:self.rear+1]
        return result
