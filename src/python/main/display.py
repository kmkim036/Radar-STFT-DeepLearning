import pygame
import matplotlib.pyplot as plt


SCREEN_WIDTH = 1200
SCREEN_HEIGHT = 800
SIZE = 100

white = (255, 255, 255)
black = (0, 0, 0)
red = (255, 0, 0)
grey = (128, 128, 128)
yellow = (255, 204, 0)

pygame.init()
pygame.display.set_caption("Display Prediction")
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))

font = pygame.font.Font('freesansbold.ttf', 50)
text_waiting = font.render("waiting...", True, black)
text_walk = font.render("motion: walk", True, black)
text_stride = font.render("motion: stride", True, black)
text_creep = font.render("motion: creep", True, black)
text_M1 = font.render("human: Man 1", True, black)
text_M2 = font.render("human: Man 2", True, black)
text_W1 = font.render("human: Woman 1", True, black)
text_W2 = font.render("human: Woman 2", True, black)


def display_init():
    screen.fill(white)
    screen.blit(text_waiting, (500, 400))
    pygame.display.update()


def display_result(image, motion, human):
    # display stft result with image
    plt.close()
    plt.ion()
    plt.figure("STFT spectrogram")
    plt.imshow(image, vmin=0, aspect='auto')

    mngr = plt.get_current_fig_manager()
    mngr.window.wm_geometry("+650+200")     # x+y
    
    plt.show()
    plt.colorbar()
    plt.pause(1)

    # display predcition with motion and human
    screen.fill(white)
    if motion == 0:
        text_motion = text_walk
    elif motion == 1:
        text_motion = text_stride
    else:
        text_motion = text_creep
    if human == 0:
        text_human = text_M1
    elif human == 1:
        text_human = text_M2
    elif human == 2:
        text_human = text_W1
    else:
        text_human = text_W2
    screen.blit(text_motion, (400, 600))
    screen.blit(text_human, (400, 700))
    pygame.display.update()
