"""
Contact Page using formsubmit.co API
"""
import streamlit as st
from streamlit_lottie import st_lottie
from utils import *

st.set_page_config(
        page_title="AI Audio Transciber",
        page_icon="./assets/favicon.png",
        layout= "wide",
        initial_sidebar_state="expanded",
        menu_items={
        'Get Help': 'https://github.com/DerKodex/AIAudioTranscriber',
        'Report a bug': "https://github.com/DerKodex/AIAudioTranscriber/issues",
        'About': "## A minimalistic application to generate transcriptions for audio built using Python"
        } )



st.title(":mailbox: Get In Touch With Me!")
hide_footer()

# Load Stylesheet(s) for relevant components
css_local("assets/styles/contact.css")
# Load and display animation
anim = lottie_local("assets/animations/contact.json")
st_lottie(anim,
            speed=1,
            reverse=False,
            loop=True,
            quality="medium", # low; medium ; high
            # renderer="svg", # canvas
            height=400,
            width=400,
            key=None,
            )


