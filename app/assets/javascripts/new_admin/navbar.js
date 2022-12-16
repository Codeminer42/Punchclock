const tabButtons = Array.from(document.querySelectorAll("[data-tab-id]"));

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

tabButtons.forEach((buttonElement) => {
  buttonElement.addEventListener("click", () => {
    showTab(buttonElement.dataset.tabId);
  });
});
tabButtons[0].click();
