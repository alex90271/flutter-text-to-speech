import tkinter as Tk
import os

#https://cloud.google.com/text-to-speech/docs/ssml how to format ssml

def insert_break():
    pass #<break time="1s"/>
def insert_emphasis():
    pass
def change_pitch():
    pass
def change_rate():
    pass
def change_voice():
    pass
def get_voices():
    pass

def synthesize_ssml(ssml, lang_name, pitch, rate):
    """Synthesizes speech from the input string of ssml.
    
    Note: ssml must be well-formed according to:
        https://www.w3.org/TR/speech-synthesis/
        
    Example: <speak>Hello there.</speak>
    """
    from google.cloud import texttospeech
    client = texttospeech.TextToSpeechClient()

    synthesis_input = texttospeech.types.SynthesisInput(ssml=ssml)

    # Note: the voice can also be specified by name.
    # Names of voices can be retrieved with client.list_voices().
    voice = texttospeech.types.VoiceSelectionParams(
        language_code='en-US',
        name=lang_name,
        ssml_gender=texttospeech.enums.SsmlVoiceGender.MALE)

    audio_config = texttospeech.types.AudioConfig(
        pitch=pitch,
        speaking_rate=rate,
        audio_encoding=texttospeech.enums.AudioEncoding.FLAC)

    response = client.synthesize_speech(synthesis_input, voice, audio_config)

    return response

# [END tts_synthesize_ssml]


if __name__ == '__main__':

    text = "" #This is the actually SSML text formating for the code to 'speak'
    lang_name = 'en-US-Wavenet-D' #this is the language code from Google. supported types: https://cloud.google.com/text-to-speech/docs/voices, 'en-US-Wavenet' subsets ONLY
    pitch = 4 #voice pitch
    rate = 1 #speaking rate

    tk = Tk()

    response = synthesize_ssml(text, lang_name, pitch, rate) #returns audio binary

    with open('output.flac', 'wb') as out:  #converts audio binary to an audio file
        out.write(response.audio_content)
        print('Audio content written to file "output.flac"')