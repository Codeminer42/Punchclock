const tabButtons = Array.from(document.querySelectorAll("button[data-tab-id]"));

const showElement = (element) => {
  element.style.display = "block";
};
const hideElement = (element) => {
  element.style.display = "none";
};

const showTab = (id) => {
  const tabContent = Array.from(
    document.querySelector("[data-tab-content]").children
  );
  tabContent.forEach((element) => {
    const shouldIShow = id === element.id;

    if (shouldIShow) {
      showElement(element);
    } else {
      hideElement(element);
    }
  });
};

const addActiveClass = (element) => {
  element.classList.add("bg-primary-600")
  element.classList.remove("bg-primary-400")
}

const removeActiveClass = (element) => {
  element.classList.remove("bg-primary-600")
  element.classList.add("bg-primary-400")
}

const setActiveButton = (activeButton) => {
  tabButtons.forEach((button) => {
    const isActive = button === activeButton

    if (isActive) {
      addActiveClass(button)
    }
    else {
      removeActiveClass(button)
    }
  })
}

tabButtons.forEach((buttonElement) => {
  buttonElement.addEventListener("click", () => {
    showTab(buttonElement.dataset.tabId);
    setActiveButton(buttonElement)
  });
});

if (tabButtons && tabButtons[0] && typeof tabButtons[0].click === 'function') {
   tabButtons[0].click();
}

window.addEventListener("load", () => {
  const anchor = window.location.hash
  if(String(anchor).includes('#')) {
    tabButtons[4].click();
  }
})
