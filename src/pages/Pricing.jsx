function Pricing() {
    return (
        <div style={styles.container}>
            <h1>Pricing</h1>
            <h3>Starter - ₹4,999</h3>
            <h3>Professional - ₹9,999</h3>
            <h3>Enterprise - ₹19,999</h3>
        </div>
    );
}

const styles = {
    container: {
        padding: "60px",
    },
};

export default Pricing;