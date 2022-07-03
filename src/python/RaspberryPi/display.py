import pygame
import matplotlib.pyplot as plt


SCREEN_WIDTH = 1920
SCREEN_HEIGHT = 1080

SIZE = 100

white = (255, 255, 255)
black = (0, 0, 0)
red = (255, 0, 0)
grey = (128, 128, 128)
yellow = (255, 204, 0)

pygame.init()
pygame.display.set_caption("Display Prediction")
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))

font = pygame.font.Font('freesansbold.ttf', 80)
text_waiting = font.render("waiting...", True, black)
text_walk = font.render("motion: walk", True, black)
text_stride = font.render("motion: stride", True, black)
text_creep = font.render("motion: creep", True, black)
text_M1 = font.render("human:  Man 1", True, black)
text_M2 = font.render("human:  Man 2", True, black)
text_W1 = font.render("human: Woman 1", True, black)
text_W2 = font.render("human: Woman 2", True, black)


def display_init():
    screen.fill(white)
    screen.blit(text_waiting, (int(0.42 * SCREEN_WIDTH),
                int(0.5 * SCREEN_HEIGHT)))
    pygame.display.update()


def display_result(image, motion, human):
    # display stft result with image
    plt.close()
    plt.ion()
    plt.figure("STFT spectrogram")
    plt.imshow(image, vmin=0, aspect='auto')

    mngr = plt.get_current_fig_manager()
    window_position = "+" + \
        str(int(0.33 * SCREEN_WIDTH)) + "+" + \
        str(int(0.15 * SCREEN_HEIGHT))    # +x+y
    mngr.window.wm_geometry(window_position)

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
    screen.blit(text_motion, (int(0.35 * SCREEN_WIDTH),
                int(0.65 * SCREEN_HEIGHT)))
    screen.blit(text_human, (int(0.34 * SCREEN_WIDTH),
                int(0.775 * SCREEN_HEIGHT)))
    pygame.display.update()
